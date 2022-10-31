targetScope = 'subscription'

@description('Name of the resourceGroup to create')
param resourceGroupName string

@description('Location for the resourceGroup')
param resourceGroupLocation string

@description('principalId of the user that will be given contributor access to the resourceGroup')
param principalId string

@description('roleDefinition to apply to the resourceGroup - default is contributor')
param roleDefinitionId string = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

@description('Unique name for the roleAssignment in the format of a guid')
param roleAssignmentName string = guid(principalId, roleDefinitionId, resourceGroupName)

var roleID = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionId}'

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2019-10-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
  properties: {}
}

module assignRole 'role.bicep' = {
  name: 'assignRBACRole'
  scope: newResourceGroup
  params: {
    principalId: principalId
    roleNameGuid: roleAssignmentName
    roleDefinitionId: roleID
  }
}
