targetScope = 'subscription'

@description('Name of the resourceGroup to create')
param resourceGroupName string

@description('Location for the resourceGroup')
param resourceGroupLocation string

@description('principalId of the user that will be given contributor access to the resourceGroup')
param principalIdOwner string
param principalIdContributor string
param principalIdReader string


@description('roleDefinition to apply to the resourceGroup - default is contributor')
param roleDefinitionIdOwner string 
param roleDefinitionIdContributor string 
param roleDefinitionIdReader string 



@description('Unique name for the roleAssignment in the format of a guid')
// param roleAssignmentNameOwner string = guid(principalIdOwner, roleDefinitionIdOwner, resourceGroupName)
// param roleAssignmentNameContributor string = guid(principalIdContributor, roleDefinitionIdContributor, resourceGroupName)
// param roleAssignmentNameReader string = guid(principalIdReader, roleDefinitionIdReader, resourceGroupName)

var roleIDOwner = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionIdOwner}'
var roleIDContributor = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionIdContributor}'
var roleIDReader = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionIdReader}'

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2019-10-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
  properties: {}
}

module assignRoleOwner 'owner_role.bicep' = {
  name: 'assignRBACRoleOwner'
  scope: newResourceGroup
  params: {
    principalIdOwner: principalIdOwner
    //roleNameGuidOwner: roleAssignmentNameOwner
    roleDefinitionIdOwner: roleIDOwner
  }
  
}
module assignRoleContributor 'contributor_role.bicep' = {
  name: 'assignRBACRoleContributor'
  scope: newResourceGroup
  params: {
    principalIdContributor: principalIdContributor
    //roleNameGuidContributor: roleAssignmentNameContributor
    roleDefinitionIdContributor: roleIDContributor
  }
  
}
module assignRole 'reader_role.bicep' = {
  name: 'assignRBACRoleReader'
  scope: newResourceGroup
  params: {
    principalIdReader: principalIdReader
    //roleNameGuidReader: roleAssignmentNameReader
    roleDefinitionIdReader: roleIDReader
  }
  
}
