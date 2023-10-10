// in go package main is the entry point of the program
// to run the program, use go run main.go
package main

// the fmt package is used to print to stdout
import (
	"fmt"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
	fmt.Println("Hello, world!")
}

// title case is exported
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap:   map[string]*schema.Resource{},
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
				Type:        schema.TypeString,
				Required:    true,
				Description: "The user uuid for the API",
				//ValidateFunc: validateUUID
			},
		},
	}
	//p.ConfigureContextFunc = providerConfigure(p)
	return p
}

//func validateUUID(v interface{}, k string) (ws []string, errors []error) {
//	log.Print('validateUUID:start')
//	value := v.(string)
//	if _,err = uuid.Parse(value); err != nil {
//		errors = append(error, fmt.Errorf("invalid UUID format"))
//	}
//	log.Print('validateUUID:end')
//}
