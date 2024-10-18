# connector-terraform

The kafka connector will storge messages from kafka in Azure blob storage.

## Example

```
module "connector" {
    source = "github.com/Eidsiva-Energi/terraform-modules/kafka-connector"

    name = "myconnector"

    cluster_id     = local.cluster_id
    environment_id = local.environment_id

    service_account_id = confluent_service_account.system["mysystem"].id

    account_name = "myserviceaccount"
    container_name = "mycontainer"
    account_key = "********"

    topics = {
        mytopic = {
            topic_name = "public.hr.ifs.companyorg"
        }
        mysecondtopic = {
            topic_name = "public.hr.companyperson"
        }
    }

    data_format = "JSON"
    time_interval = "DAILY"
    path_format = "'year'=YYYY/'month'=MM/'day'=dd"
}
```