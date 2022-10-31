@description('The principal to assign the role to')
param principalIdContributor string

@description('A GUID used to identify the role assignment')
param roleNameGuidContributor string = newGuid()

param roleDefinitionIdContributor string

resource roleNameGuid_resource 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuidContributor
  properties: {
    roleDefinitionId: roleDefinitionIdContributor
    principalId: principalIdContributor
    principalType: 'Group'
  }
}
