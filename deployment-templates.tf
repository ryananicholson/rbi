resource "azurerm_resource_group_template_deployment" "sec488-frontdoor" {
  name                = "sec488-frontdoor-deploy"
  resource_group_name = azurerm_resource_group.sec488-rg.name
  deployment_mode     = "Incremental"
  template_content    = <<TEMPLATE
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "resources": [
        {
            "type": "Microsoft.Network/frontdoors",
            "apiVersion": "2020-05-01",
            "name": "sec488-${random_string.sec488-id.result}",
            "location": "global",
            "tags": {},
            "properties": {
                "frontdoorId": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}",
                "friendlyName": "sec488-${random_string.sec488-id.result}",
                "enabledState": "Enabled",
                "healthProbeSettings": [
                    {
                        "name": "healthProbeSettings-1613832938092",
                        "properties": {
                            "path": "/",
                            "protocol": "Http",
                            "intervalInSeconds": 30,
                            "healthProbeMethod": "Head",
                            "enabledState": "Enabled"
                        },
                        "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/healthProbeSettings/healthProbeSettings-1613832938092"
                    }
                ],
                "loadBalancingSettings": [
                    {
                        "name": "loadBalancingSettings-1613832938092",
                        "properties": {
                            "sampleSize": 1,
                            "successfulSamplesRequired": 1,
                            "additionalLatencyMilliseconds": 0
                        },
                        "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/loadBalancingSettings/loadBalancingSettings-1613832938092"
                    }
                ],
                "frontendEndpoints": [
                    {
                        "name": "sec488-${random_string.sec488-id.result}-azurefd-net",
                        "properties": {
                            "hostName": "sec488-${random_string.sec488-id.result}.azurefd.net",
                            "sessionAffinityEnabledState": "Disabled",
                            "sessionAffinityTtlSeconds": 0,
                            "webApplicationFirewallPolicyLink": null,
                            "customHttpsConfiguration": null
                        },
                        "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/frontendEndpoints/sec488-${random_string.sec488-id.result}-azurefd-net"
                    }
                ],
                "backendPools": [
                    {
                        "name": "sec488-backend",
                        "properties": {
                            "backends": [
                                {
                                    "address": "${azurerm_public_ip.sec488-hrweb-pip.ip_address}",
                                    "privateLinkResourceId": null,
                                    "privateLinkLocation": null,
                                    "privateEndpointStatus": null,
                                    "privateLinkApprovalMessage": null,
                                    "enabledState": "Enabled",
                                    "httpPort": 80,
                                    "httpsPort": 443,
                                    "priority": 1,
                                    "weight": 50,
                                    "backendHostHeader": "${azurerm_public_ip.sec488-hrweb-pip.ip_address}"
                                }
                            ],
                            "loadBalancingSettings": {
                                "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/loadBalancingSettings/loadBalancingSettings-1613832938092"
                            },
                            "healthProbeSettings": {
                                "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/healthProbeSettings/healthProbeSettings-1613832938092"
                            }
                        },
                        "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/backendPools/sec488-backend"
                    }
                ],
                "routingRules": [
                    {
                        "name": "sec488-rr",
                        "properties": {
                            "frontendEndpoints": [
                                {
                                    "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/frontendEndpoints/sec488-${random_string.sec488-id.result}-azurefd-net"
                                }
                            ],
                            "acceptedProtocols": [
                                "Https"
                            ],
                            "patternsToMatch": [
                                "/*"
                            ],
                            "enabledState": "Enabled",
                            "routeConfiguration": {
                                "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
                                "customForwardingPath": null,
                                "forwardingProtocol": "HttpOnly",
                                "backendPool": {
                                    "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/backendPools/sec488-backend"
                                },
                                "cacheConfiguration": null
                            }
                        },
                        "id": "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/SEC488-RG/providers/Microsoft.Network/frontdoors/sec488-${random_string.sec488-id.result}/routingRules/sec488-rr"
                    }
                ],
                "backendPoolsSettings": {
                    "enforceCertificateNameCheck": "Disabled",
                    "sendRecvTimeoutSeconds": 30
                }
            }
        }
    ]
}
TEMPLATE
  depends_on          = [azurerm_linux_virtual_machine.sec488-hrweb]
}
