// See https://aka.ms/new-console-template for more information
using Microsoft.Crm.Sdk.Messages;
using Microsoft.PowerPlatform.Dataverse.Client;
using Microsoft.Xrm.Sdk.Metadata;
using System.Configuration;
using TableCreator;
using static TableCreator.Common.Common;

try
{
    var instanceUri = new Uri(ConfigurationManager.AppSettings["instanceUri"]);
    var instanceName = ConfigurationManager.AppSettings["instanceName"];
    var clientId = ConfigurationManager.AppSettings["clientId"];
    var clientSecret = ConfigurationManager.AppSettings["clientSecret"];

    var serviceClient = new ServiceClient(instanceUri, clientId, clientSecret, true);
    WhoAmIResponse whoAmIResponse = (WhoAmIResponse)serviceClient.Execute(new WhoAmIRequest());

    //Console.WriteLine($"Connected with UserId: {whoAmIResponse.UserId} to {instanceName} ({instanceUri})");
    //Console.WriteLine("-------------------");


EntityMenu:
    Console.WriteLine($"Connected to {instanceName}");
    Console.WriteLine("");
    Console.WriteLine("");
    Console.WriteLine("Velg entitet");

    foreach (int i in Enum.GetValues(typeof(TCEntity)))
    {
        var name = Enum.GetName(typeof(TCEntity), i);
        Console.WriteLine($"{i} - {name}");
    }

    var selectedEntityKey = Console.ReadKey();
    Console.WriteLine("");
    Console.WriteLine("");

    var entityName = "";
    var entityDisplayName = "";
    var entityDisplayNamePlural = "";
    TCOperation selectedOperation;

    var selectedEntity = (TCEntity)int.Parse(selectedEntityKey.KeyChar.ToString());
    List<AttributeMetadata> attribs;
    Console.WriteLine("");
    Console.WriteLine("");
    Console.WriteLine($"You chose {selectedEntity} ");
    Console.WriteLine("");
    Console.WriteLine("");

    switch (selectedEntity)
    {
        case TCEntity.Cancel:
            goto Exit;
        case TCEntity.Table1:
            entityName = "prefix_table1";
            entityDisplayName = "Table1";
            entityDisplayNamePlural = "Table1s";
            attribs = Table1Attribs.getAttribs();
            break;
        case TCEntity.Table2:
            entityName = "prefix_table2";
            entityDisplayName = "Table2";
            entityDisplayNamePlural = "Table2s";
            attribs = Table2Attribs.getAttribs();
            break;
        
        default:
            Console.WriteLine("WROOONG!! Try again ... ");
            Console.ReadKey();
            Console.Clear();
            goto EntityMenu;
    }

    selectedOperation = OperationsMenu();

    RunOp(selectedOperation, attribs, entityName, entityDisplayName, entityDisplayNamePlural, serviceClient);
    Console.WriteLine("");
    Console.WriteLine("FINISHED !! ");
    Console.WriteLine("");
    Console.WriteLine("Now click something..");
    Console.WriteLine("");
    Console.ReadKey();
    Console.Clear();
    goto EntityMenu;

Exit:
    Console.WriteLine("...");
    Console.WriteLine("Exiting");

    Console.ReadKey();

}
catch (Exception ex)
{
    throw ex;
}