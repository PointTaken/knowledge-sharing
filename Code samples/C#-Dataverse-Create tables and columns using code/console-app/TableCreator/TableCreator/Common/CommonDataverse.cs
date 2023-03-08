//using HusleieFunctions.Models;
//using Microsoft.AspNetCore.Http;
using Microsoft.PowerPlatform.Dataverse.Client;


namespace TableCreator.Common
{
    internal static class CommonDataverse
    {
        internal async static Task<Guid> AddRecordToTable(ServiceClient serviceClient, string entityName, Dictionary<string, DataverseDataTypeWrapper> keyValuePairs)
        {
            try
            {
                var recordId = serviceClient.CreateNewRecord(entityName, keyValuePairs);//, batchId: batchId);

                if (recordId != Guid.Empty)
                {
                    return recordId;
                }
                else
                {
                    throw new InvalidDataException();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
