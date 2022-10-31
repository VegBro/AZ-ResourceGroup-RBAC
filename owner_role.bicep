@description('The principal to assign the role to')
param principalIdOwner string

@description('A GUID used to identify the role assignment')
param roleNameGuidOwner string = newGuid()

param roleDefinitionIdOwner string

resource roleNameGuid_resource 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleNameGuidOwner
  properties: {
    roleDefinitionId: roleDefinitionIdOwner
    principalId: principalIdOwner
    principalType: 'Group'
  }
}
