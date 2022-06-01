package test

import (
	"context"
	"crypto/tls"
	"errors"
	"os"
	"testing"
	"time"

	"github.com/Azure/azure-sdk-for-go/services/frontdoor/mgmt/2020-11-01/frontdoor"
	"github.com/gruntwork-io/terratest/modules/azure"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const (
	// AzureSubscriptionID is an optional env variable supported by the `azurerm` Terraform provider to
	// designate a target Azure subscription ID
	AzureSubscriptionID = "ARM_SUBSCRIPTION_ID"

	// AzureResGroupName is an optional env variable custom to Terratest to designate a target Azure resource group
	AzureResGroupName = "tfmodulevalidation-test-group"
)

type FrontdoorValidationArgs struct {
	frontdoorName string
}

func TestAzureFrontDoor(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../example",
	})

	expectedFrontdoorArgs := FrontdoorValidationArgs{
		frontdoorName: "tfvalfrontdoor",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	validateFrontdoor(t, terraformOptions, &expectedFrontdoorArgs)

	validateFrontdoorEndpoint(t, terraformOptions, &expectedFrontdoorArgs)
}

func validateFrontdoor(t *testing.T, terraformOptions *terraform.Options, args *FrontdoorValidationArgs) {
	assertions := assert.New(t)

	id := terraform.Output(t, terraformOptions, "id")
	assertions.NotNil(id)

	fd := getFrontdoor(t, args.frontdoorName)
	assertions.NotNil(fd)
}

func validateFrontdoorEndpoint(t *testing.T, terraformOptions *terraform.Options, args *FrontdoorValidationArgs) {
	assertions := assert.New(t)

	frontendEndpointMap := terraform.OutputMap(t, terraformOptions, "frontend_endpoint_map")

	for key := range frontendEndpointMap {
		fep := getFrontendEndpoint(t, args.frontdoorName, key)
		assertions.NotNil(fep)

		// Build URL for Frontend Endpoint testing
		url := "https://" + *fep.HostName + "/switchhosts/test.txt"

		// Setup a TLS configuration to submit with the helper, a blank struct is acceptable
		tlsConfig := tls.Config{}

		// Define expected HTTP status code and body
		expectedStatus := 200
		expectedBody := ""

		// It can take a minute or so, retry a few times
		retries := 30
		sleepBetweenRetries := 5 * time.Second

		// Verify that we get back a 200 OK
		http_helper.HttpGetWithRetry(t, url, &tlsConfig, expectedStatus, expectedBody, retries, sleepBetweenRetries)
	}
}

func getFrontdoor(t *testing.T, frontDoorName string) *frontdoor.FrontDoor {
	frontDoor, err := getFrontdoorE(frontDoorName)
	require.NoError(t, err)

	return frontDoor
}

func getFrontdoorE(frontDoorName string) (*frontdoor.FrontDoor, error) {
	client, err := getFrontdoorClient()
	if err != nil {
		return nil, err
	}

	frontDoor, err := client.Get(context.Background(), AzureResGroupName, frontDoorName)
	if err != nil {
		return nil, err
	}

	return &frontDoor, nil
}

func getFrontdoorClient() (*frontdoor.FrontDoorsClient, error) {
	subID := os.Getenv(AzureSubscriptionID)
	if subID == "" {
		return nil, errors.New("Unable to retrieve Subscription ID")
	}

	client := frontdoor.NewFrontDoorsClient(subID)

	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}

	client.Authorizer = *authorizer

	return &client, nil
}

func getFrontendEndpoint(t *testing.T, frontdoorName, frontendEndpointName string) *frontdoor.FrontendEndpoint {
	frontendEndpoint, err := getFrontendEndpointE(frontdoorName, frontendEndpointName)
	require.NoError(t, err)

	return frontendEndpoint
}

func getFrontendEndpointE(frontdoorName, frontendEndpointName string) (*frontdoor.FrontendEndpoint, error) {
	client, err := getFrontendEndpointsClient()
	if err != nil {
		return nil, err
	}

	frontendEndpoint, err := client.Get(context.Background(), AzureResGroupName, frontdoorName, frontendEndpointName)
	if err != nil {
		return nil, err
	}

	return &frontendEndpoint, nil
}

func getFrontendEndpointsClient() (*frontdoor.FrontendEndpointsClient, error) {
	subID := os.Getenv(AzureSubscriptionID)
	if subID == "" {
		return nil, errors.New("Unable to retrieve Subscription ID")
	}

	client := frontdoor.NewFrontendEndpointsClient(subID)

	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}

	client.Authorizer = *authorizer

	return &client, nil
}
