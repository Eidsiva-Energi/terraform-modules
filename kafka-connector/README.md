# Kafka Connector Module

This module defines a Kafka connector that stores messages from one or multiple topics in Azure blob storage.

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
    account_key = "********"
    container_name = "mycontainer"

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

### Variables

* `name`. The name of the connector
* `account_name`. The name of the Confluent Service Account the connector will utilize.
* `account_key`. The key to to use the Confluent Service Account. Remember to keep this value secret.
* `container_name`. The name of the container in the Azure Blob Storage the connector will write to.
* `topics`. A list of the different topics the connector should read from. Each list item is an object with a `topic_name` attribute.
* `data_format`. The data format the connector will write to Azure Blob Storage. Availible options are: *JSON*, *Avro*, *Bytes*, and *Parquet*
<!-- TODO: Sjekk om det finnes flere options for time_interval -->
* `time_interval`. How often the connector writes to te Azure Blob Storage. The availible options are *DAILY* and *HOURLY*.
* `path_format`. How the folder structure in the Azure Blob Storage should be organized.