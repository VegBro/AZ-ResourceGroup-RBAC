@description('The principal to assign the role to')
param principalIdReader string

@description('A GUID used to identify the role assignment')
param roleNameGuidReader string = newGuid()

param roleDefinitionIdReader string

resource roleNameGuid_resource 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuidReader
  properties: {
    roleDefinitionId: roleDefinitionIdReader
    principalId: principalIdReader
    principalType: 'Group'
  }
}
