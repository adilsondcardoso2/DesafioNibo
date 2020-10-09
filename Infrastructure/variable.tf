variable "subscription_id" {
    type = string
    description = "(Required) ID da assinatura do Azure."
}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "resourcegroup_name" {
    type        = string
    description = "(optional) Nome para o grupo de recursos. Quando não informado, será gerado um nome aleatório para este recurso."
    default     = ""
}
variable "location" {
    type        = string
    description = "(optional) Localização GEO dos recursos. O valor padrão é Brazil South."
    default     = "brazilsouth"
}
variable "appinsights_name" {
    type        = string
    description = "(optional) Nome para recurso Application Insights. Quando não informado, será gerado um nome aleatório para este recurso."
    default     = ""
}
variable "servicePlan_name" {
    type        = string
    description = "(optional) Nome para recurso Service Plan. Quando não informado, será gerado um nome aleatório para este recurso."
    default     = ""
}
variable "appservice_name" {
    type        = string
    description = "(optional) Nome para recurso App Service. Quando não informado, será gerado um nome aleatório para este recurso."
    default     = ""
}
variable "list_cors" {
    type        = list(string)
    description = "(Required) Lista de endereço que devem poder fazer chamadas para app."
    default     = []
}
variable "default_documents" {
    type = list(string)
    description = "(Optionar) Lista de documentos padrão para carregar, se um endereço não for especificado."
    default = []
}
variable "custom_settings" {
    type = map(string)
    description = "(Optional) Adicionar novas chaves de configuração no App Settings."
    default = {}
}
variable "connection_list" {
    description = "(Optional) Lista de conexões usadas no App Service."
    type = list(object(
        {
            name  = string
            type  = string
            value = string
        }
    ))
    default = []
}