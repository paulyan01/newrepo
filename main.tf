locals{
  linux_app=[for f in fileset("${path.module}/configs", "[^_]*.yaml") : yamldecode(file("${path.module}/configs/${f}"))]
  linux_app_list = flatten([
    for app in local.linux_app : [
      for linuxapps in try(app.linux_app, []) :{
        name=linuxapps.name
        resource_group_name=linuxapps.resource_group
        location=linuxapps.location
        os_type=linuxapps.os_type
        sku_name=linuxapps.sku_name     
      }
    ]
])
}

resource "azurerm_resource_group" "azureresourcegroup" {
for_each={for rg in local.linux_app_list:"${rg.name} => rg}  
name     = each.value.name
  location = each.value.location
}
