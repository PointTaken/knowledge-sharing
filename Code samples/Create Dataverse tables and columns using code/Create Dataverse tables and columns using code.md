# Create Dataverse tables and columns using code (C#)

## A Console application for creating and updating tables, columns and relations in Dataverse

*Confessions of a programmer trapped in a no-code hellscape*

In a project we needed to develop and maintain a database structure in Dataverse between three environments (DEV, TEST, PROD). The initial plan was to use tools available in the Power Platform GUI. When they failed to update or migrate the tables and columns correctly the next step was to code it.

＼(＾O＾)／

Luckily, Microsoft has an API for that called [Microsoft.Xrm.Sdk.Metadata](https://learn.microsoft.com/en-us/dotnet/api/microsoft.xrm.sdk.metadata?view=dataverse-sdk-latest)

Our solution was to write a small console app to handle all database worries.

**Disclaimer:** This app was written with minimal effort and is not very elaborate. It requires a few manual setup steps to work (described below).

The app consists of:

-   A simple menu to select which table to work with
-   A submenu to determine the action
    -   create table
    -   handle table relations
    -   create columns
    -   update columns
-   Communication with Dataverse is done using a ServiceClient
-   Column definitions are hard coded as classes (one class per table), but the solution could quickly be altered to handle config xml/json
-   Prefix should be the default prefix in your environment
-   Switching between environments is done in the app.config

Columns are defined with type specific AttributMetadata

**String:**

```csharp
    new StringAttributeMetadata
    {
        SchemaName = "prefix_columnname",
        LogicalName = "prefix_columnname",
        DisplayName = new Label("Column Displayname", 1044),
        RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.None),
        Description = new Label("Some description", 1044),
        MaxLength = 1000
    }

```

**Decimal:**

```csharp
    new DecimalAttributeMetadata
    {
        SchemaName = "prefix_columnname",
        LogicalName = "prefix_columnname",
        DisplayName = new Label("Column Displayname", 1044),
        RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.None),
        Description = new Label("Some description", 1044),
        MinValue = -100000000000,
        MaxValue = 100000000000,
        Precision = 10,
    }

```

**To use the app:**

-   Add your tables to the TCEntity enum
-   Update the switch case beginning on line 52 of Program.cs with your table info
-   Relation information is set manually beginning on line 51 in Common.cs
-   Add you environment info in the app.config-file

[You can view/download the console app here](https://github.com/PointTaken/knowledge-sharing/tree/main/Code%20samples/CSharp-Dataverse-Create%20tables%20and%20columns%20using%20code/console-app)