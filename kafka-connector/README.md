# connector-terraform

The kafka connector will store messages from kafka in Azure blob storage.

## Example 1
This example defines a connector called `myconnector` that writes the contents for the topics `public.hr.ifs.companyorg` and `public.hr.companyperson` to Azure blob storage. The contents are saved daily as JSON files and the files are organized by which day they were written.

```c
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