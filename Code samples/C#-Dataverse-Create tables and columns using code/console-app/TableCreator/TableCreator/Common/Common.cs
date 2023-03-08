using Microsoft.Crm.Sdk.Messages;
using Microsoft.PowerPlatform.Dataverse.Client;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk.Metadata;


namespace TableCreator.Common
{
    internal class Common
    {

        internal enum TCOperation
        {
            Cancel,
            Create,
            Update,
            Relations
        }

        internal enum TCEntity
        {
            Cancel,
            Table1,
            Table2
        }

        internal static bool RunOp(TCOperation operation, List<AttributeMetadata> attribs, string entityName, string entityDisplayName, string entityDisplayNamePlural, ServiceClient serviceClient)
        {
            EnsureTable(entityName, entityDisplayName, entityDisplayNamePlural, serviceClient);

            if (operation == TCOperation.Create)
            {
                var createAttribs = attribs.Select(a => AttributeFactory.createAttribute(a, entityName)).ToList();
                Console.WriteLine("");
                Console.WriteLine($"Adding new columns in table {entityName}");
                Console.WriteLine("");
                CreateColumns(entityName, createAttribs, serviceClient);
            }
            else if (operation == TCOperation.Update)
            {
                var updateAttribs = attribs.Select(a => AttributeFactory.updateAttribute(a, entityName)).ToList();
                Console.WriteLine("");
                Console.WriteLine($"Updating columns in {entityName}");
                Console.WriteLine("");

                UpdateColumns(entityName, updateAttribs, serviceClient);
            }
            else if (operation == TCOperation.Relations)
            {
                Console.WriteLine("");
                Console.WriteLine($"Updating relations in {entityName}");
                Console.WriteLine("");

                if (entityName == "prefix_table1")
                {
                    EnsureOneToManyTableRelationship("prefix_table1", "prefix_table2", serviceClient); // 1:N
                }
                //else if ...
            }

            return true;
        }

        internal static TCOperation OperationsMenu()
        {
            Console.WriteLine("Choose operation");
            TCOperation selectedOperation;

            foreach (int i in Enum.GetValues(typeof(TCOperation)))
            {
                var name = Enum.GetName(typeof(TCOperation), i);
                Console.WriteLine($"{i} - {name}");
            }
            var selectedOp = Console.ReadKey();
            try
            {
                selectedOperation = (TCOperation)int.Parse(selectedOp.KeyChar.ToString());
            }
            catch
            {
                return TCOperation.Cancel;
            }

            Console.WriteLine("");
            Console.WriteLine("");
            return selectedOperation;
        }

        internal static bool EnsureTable(string entityName, string entityDisplayName, string entityDisplayNamePlural, ServiceClient serviceClient, bool enableAudit = false)
        {
            Console.WriteLine($"Ensuring that table {entityName} exists");
            try
            {
                var displayName = serviceClient.GetEntityDisplayName(entityName);
                if (!string.IsNullOrEmpty(displayName))
                {
                    return true;
                }
            }
            catch
            {
                // Fail silently and continue creating the entity
            }

            try
            {

                CreateEntityRequest createrequest = new CreateEntityRequest
                {
                    Entity = new EntityMetadata
                    {
                        SchemaName = entityName,
                        DisplayName = new Label(entityDisplayName, 1044),
                        DisplayCollectionName = new Label(entityDisplayNamePlural, 1044),
                        Description = new Label("", 1044),
                        OwnershipType = OwnershipTypes.UserOwned,
                        IsActivity = false,
                        IsAuditEnabled = new BooleanManagedProperty(enableAudit),
                    },

                    // Define the primary attribute for the entity
                    PrimaryAttribute = new StringAttributeMetadata
                    {
                        SchemaName = $"{entityName}name",
                        RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.None),
                        MaxLength = 800,
                        FormatName = StringFormatName.Text,
                        DisplayName = new Label($"{entityDisplayName}navn", 1044),
                        Description = new Label("", 1044)
                    }

                };
                serviceClient.Execute(createrequest);
                Console.WriteLine(@$"Entity {entityName} has been created.");
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal static bool EnsureOneToManyTableRelationship(string fromTable, string toTable, ServiceClient serviceClient)
        {

            Console.WriteLine($"Checking relation from {fromTable} to {toTable}");

            try
            {
                var relationshipName = @$"rel_{fromTable}_{toTable}";
                if (CheckRelationshipExists(relationshipName, serviceClient))
                {
                    return true;
                }

                if (EligibleCreateOneToManyRelationship(fromTable, toTable, serviceClient))
                {
                    var relationship = new OneToManyRelationshipMetadata
                    {
                        ReferencedEntity = fromTable,
                        ReferencingEntity = toTable,
                        SchemaName = relationshipName,
                        AssociatedMenuConfiguration = new AssociatedMenuConfiguration
                        {
                            Behavior = AssociatedMenuBehavior.UseLabel,
                            Group = AssociatedMenuGroup.Details,
                            Label = new Label(toTable, 1044),
                            Order = 10000
                        },
                        CascadeConfiguration = new CascadeConfiguration
                        {
                            Assign = CascadeType.NoCascade,
                            Delete = CascadeType.RemoveLink,
                            Merge = CascadeType.NoCascade,
                            Reparent = CascadeType.NoCascade,
                            Share = CascadeType.NoCascade,
                            Unshare = CascadeType.NoCascade
                        }
                    };
                    var request = new CreateOneToManyRequest
                    {
                        OneToManyRelationship = relationship,
                        Lookup = new LookupAttributeMetadata
                        {
                            SchemaName = "rel_" + fromTable,
                            DisplayName = new Label(fromTable + "_lookup", 1044),
                            RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.None),
                            Description = new Label("", 1044)
                        }
                    };

                    var result = (CreateOneToManyResponse)serviceClient.Execute(request);
                }

                Console.WriteLine($"1:N-relation {relationshipName} was created between {fromTable} and {toTable}.");

                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal static bool EnsureManyToManyTableRelationship(string fromTable, string toTable, ServiceClient serviceClient)
        {
            Console.WriteLine($"Checking relation between {fromTable} and  {toTable}");

            try
            {
                var relationshipName = @$"rel_{fromTable}_{toTable}";
                var intersectTableName = @$"rel_intersect_{fromTable}_{toTable}";
                if (CheckRelationshipExists(relationshipName, serviceClient))
                {
                    return true;
                }

                bool fromTableEligibleParticipate = EligibleCreateManyToManyRelationship(fromTable, serviceClient);
                bool toTableEligibleParticipate = EligibleCreateManyToManyRelationship(toTable, serviceClient);

                if (fromTableEligibleParticipate && toTableEligibleParticipate)
                {

                    CreateManyToManyRequest createManyToManyRelationshipRequest =
                        new CreateManyToManyRequest
                        {
                            IntersectEntitySchemaName = intersectTableName,
                            ManyToManyRelationship = new ManyToManyRelationshipMetadata
                            {
                                SchemaName = relationshipName,
                                Entity1LogicalName = fromTable,
                                Entity1AssociatedMenuConfiguration =
                                    new AssociatedMenuConfiguration
                                    {
                                        Behavior = AssociatedMenuBehavior.UseLabel,
                                        Group = AssociatedMenuGroup.Details,
                                        Label = new Label(fromTable, 1044),
                                        Order = 10000
                                    },
                                Entity2LogicalName = toTable,
                                Entity2AssociatedMenuConfiguration =
                                    new AssociatedMenuConfiguration
                                    {
                                        Behavior = AssociatedMenuBehavior.UseLabel,
                                        Group = AssociatedMenuGroup.Details,
                                        Label = new Label(toTable, 1044),
                                        Order = 10000
                                    }
                            }
                        };

                    CreateManyToManyResponse createManytoManyRelationshipResponse = (CreateManyToManyResponse)serviceClient.Execute(createManyToManyRelationshipRequest);

                    Console.WriteLine($"N:N-relation {relationshipName} was created between {fromTable} and {toTable}.");

                    return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal static void SetSeedValueForColumn(string entityName, string attribName, int seedValue, ServiceClient serviceClient)
        {
            serviceClient.Execute(new SetAutoNumberSeedRequest
            {
                EntityName = entityName,
                AttributeName = attribName,
                Value = seedValue
            });
        }

        internal static void CreateColumns(string entityName, List<CreateAttributeRequest> attribs, ServiceClient serviceClient)
        {
            if (!string.IsNullOrEmpty(entityName))
            {
                foreach (var attr in attribs)
                {
                    try
                    {
                        serviceClient.Execute(attr);
                        Console.ForegroundColor = ConsoleColor.Yellow;
                        Console.WriteLine(attr.Attribute.SchemaName);
                        Console.ForegroundColor = ConsoleColor.White;
                    }
                    catch (Exception ex)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine(ex.Message);
                        Console.ForegroundColor = ConsoleColor.White;
                    }
                }

                var publish = new PublishXmlRequest { ParameterXml = $"<importexportxml><entities><entity>{entityName}</entity></entities></importexportxml>" };
                serviceClient.Execute(publish);
            }
        }

        internal static void UpdateColumns(string entityName, List<UpdateAttributeRequest> attribs, ServiceClient serviceClient)
        {

            if (!string.IsNullOrEmpty(entityName))
            {
                foreach (var attr in attribs)
                {
                    try
                    {
                        serviceClient.Execute(attr);
                        Console.ForegroundColor = ConsoleColor.Yellow;
                        Console.WriteLine(attr.Attribute.SchemaName);
                        Console.ForegroundColor = ConsoleColor.White;
                    }
                    catch (Exception ex)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine(ex.Message);
                        Console.ForegroundColor = ConsoleColor.White;
                    }
                }

                var publish = new PublishXmlRequest { ParameterXml = $"<importexportxml><entities><entity>{entityName}</entity></entities></importexportxml>" };
                serviceClient.Execute(publish);
            }
        }

        //https://docs.microsoft.com/en-us/powerapps/developer/data-platform/org-service/metadata-relationshipmetadata#eligiblecreateonetomanyrelationship
        private static bool EligibleCreateManyToManyRelationship(string table, ServiceClient serviceClienty)
        {
            CanManyToManyRequest canManyToManyRequest = new CanManyToManyRequest
            {
                EntityName = table
            };

            CanManyToManyResponse canManyToManyResponse =
                (CanManyToManyResponse)serviceClienty.Execute(canManyToManyRequest);

            if (!canManyToManyResponse.CanManyToMany)
            {
                Console.WriteLine(
                    "Entity {0} can't participate in a many-to-many relationship.",
                    table);
            }

            return canManyToManyResponse.CanManyToMany;
        }

        private static bool EligibleCreateOneToManyRelationship(string fromTable, string toTable, ServiceClient serviceClient)
        {

            //Checks whether the specified entity can be the primary entity in one-to-many relationship.
            CanBeReferencedRequest canBeReferencedRequest = new CanBeReferencedRequest
            {
                EntityName = fromTable
            };

            CanBeReferencedResponse canBeReferencedResponse = (CanBeReferencedResponse)serviceClient.Execute(canBeReferencedRequest);

            if (!canBeReferencedResponse.CanBeReferenced)
            {
                Console.WriteLine("Entity {0} can't be the primary entity in this one-to-many relationship", fromTable);
            }

            //Checks whether the specified entity can be the referencing entity in one-to-many relationship.
            CanBeReferencingRequest canBereferencingRequest = new CanBeReferencingRequest
            {
                EntityName = toTable
            };

            CanBeReferencingResponse canBeReferencingResponse = (CanBeReferencingResponse)serviceClient.Execute(canBereferencingRequest);

            if (!canBeReferencingResponse.CanBeReferencing)
            {
                Console.WriteLine("Entity {0} can't be the referencing entity in this one-to-many relationship", toTable);
            }


            if (canBeReferencedResponse.CanBeReferenced == true && canBeReferencingResponse.CanBeReferencing == true)
            {
                return true;
            }
            else
            {
                return false;
            }
        }



        private static bool CheckRelationshipExists(string relationshipName, ServiceClient serviceClient)
        {

            ////Retrieve the Many-to-many relationship using the Name.
            ///
            try
            {
                RetrieveRelationshipRequest request = new RetrieveRelationshipRequest { Name = relationshipName };
                RetrieveRelationshipResponse response = (RetrieveRelationshipResponse)serviceClient.Execute(request);

                if (response.Results.Any())
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {

                return false;
            }

        }


    }
}
