// in go package main is the entry point of the program
// to run the program, use go run main.go
package main

// the fmt package is used to print to stdout
import (
	"bytes"
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
	fmt.Println("Hello, world!")
}

type Config struct {
	Endpoint string
	Token    string
	UserUuid string
}

// title case is exported
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"terratowns_home": Resource(),
		},
		DataSourcesMap: map[string]*schema.Resource{},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The endpoint of the API",
			},
			"token": {
				Type:        schema.TypeString,
				Sensitive:   true, // this will hide the value from the terraform state
				Required:    true,
				Description: "The token for the API",
			},
			"user_uuid": {
				Type:         schema.TypeString,
				Required:     true,
				Description:  "The user uuid for the API",
				ValidateFunc: validateUUID,
			},
		},
	}
	p.ConfigureContextFunc = providerConfigure(p)
	return p
}

func validateUUID(v interface{}, k string) (ws []string, errors []error) {
	log.Print("validateUUID:start")
	value := v.(string)
	if _, err := uuid.Parse(value); err != nil {
		errors = append(errors, fmt.Errorf("invalid UUID format"))
	}
	log.Print("validateUUID:end")
	return
}

func providerConfigure(p *schema.Provider) schema.ConfigureContextFunc {
	log.Print("providerConfigure:start")
	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
		log.Print("providerConfigure:configure:start")
		config := Config{
			Endpoint: d.Get("endpoint").(string),
			Token:    d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("providerConfigure:configure:end")
		return &config, nil
	}
}

func Resource() *schema.Resource {
	log.Print("Resource:start")
	resource := &schema.Resource{
		CreateContext: resourceHouseCreate,
		ReadContext:   resourceHouseRead,
		UpdateContext: resourceHouseUpdate,
		DeleteContext: resourceHouseDelete,
		Schema: map[string]*schema.Schema{
			"name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The name of the house",
			},
			"description": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The description of the house",
			},
			"domain_name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The domain name of the house",
			},
			"town": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The town the house will belong to",
			},
			"content_version": {
				Type:        schema.TypeInt,
				Required:    true,
				Description: "The content version of the house",
			},
		},
	}
	log.Print("Resource:end")
	return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseCreate:start")
	var diags diag.Diagnostics
	config := m.(*Config)

	paylod := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"domain_name":     d.Get("domain_name").(string),
		"town":            d.Get("town").(string),
		"content_version": d.Get("content_version").(int),

payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	// construct the HTTP request
	req, err := http.NewRequest("POST", config.Endpoint+"/u/"+config.UserUuid+"/homes", bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)
	}
	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// decode the response
	var responseDate map[string]interface{}
	if err:= json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	// handle response status code not ok
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to create house, status code: %d", resp.StatusCode))
	}

	log.Print("resourceHouseCreate:end")
	return diags
}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseRead:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	// construct the HTTP request

	homeUUID := d.Id()

	req, err := http.NewRequest("GET", config.Endpoint+"/u/"+config.UserUuid+"/homes"+homeUUID, nil)
	if err != nil {
		return diag.FromErr(err)
	}
	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// decode the response
	var responseDate map[string]interface{}
	if err:= json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	// handle response status code not ok
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to read house, status code: %d", resp.StatusCode))
	}

	log.Print("resourceHouseRead:end")
	return diags
}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseUpdate:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	// construct the HTTP request
	req, err := http.NewRequest("PUT", config.Endpoint+"/u/"+config.UserUuid+"/homes"+homeUUID, nil)
	if err != nil {
		return diag.FromErr(err)
	}
	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// handle response status code not ok
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to update house, status code: %d", resp.StatusCode))
	}

	log.Print("resourceHouseUpdate:end")
	return diags
}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseDelete:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	// construct the HTTP request
	req, err := http.NewRequest("DELETE", config.Endpoint+"/u/"+config.UserUuid+"/homes"+homeUUID, nil)
	if err != nil {
		return diag.FromErr(err)
	}

	// set headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// handle response status code not ok
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to delete house, status code: %d", resp.StatusCode))
	}

	log.Print("resourceHouseDelete:end")
	return diags
}
