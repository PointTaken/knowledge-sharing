using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk.Metadata;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TableCreator
{
    internal class Table2Attribs
    {
        public static List<AttributeMetadata> getAttribs()
        {
            var attribs = new List<AttributeMetadata>();

            /**
             * Meta
             * */
            attribs.Add(new DecimalAttributeMetadata
            {
                SchemaName = "husleie_realrente",
                LogicalName = "husleie_realrente",
                DisplayName = new Label("Realrente", 1044),
                RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.ApplicationRequired),
                Description = new Label("", 1044),
                MinValue = -100000000000,
                MaxValue = 100000000000,
                Precision = 10,
            });

            attribs.Add(new DecimalAttributeMetadata
            {
                SchemaName = "husleie_forventet_prisstigning",
                LogicalName = "husleie_forventet_prisstigning",
                DisplayName = new Label("Forventet prisstigning", 1044),
                RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.ApplicationRequired),
                Description = new Label("", 1044),
                MinValue = -100000000000,
                MaxValue = 100000000000,
                Precision = 10,
            });

            attribs.Add(new DecimalAttributeMetadata
            {
                SchemaName = "husleie_betalingstyngdepunkt",
                LogicalName = "husleie_betalingstyngdepunkt",
                DisplayName = new Label("Betalingstyngdepunkt", 1044),
                RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.ApplicationRequired),
                Description = new Label("", 1044),
                MinValue = -100000000000,
                MaxValue = 100000000000,
                Precision = 10,
            });

            attribs.Add(new DecimalAttributeMetadata
            {
                SchemaName = "husleie_indeksregulering_intervall",
                LogicalName = "husleie_indeksregulering_intervall",
                DisplayName = new Label("Indeksregulering intervall", 1044),
                RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.ApplicationRequired),
                Description = new Label("", 1044),
                MinValue = -100000000000,
                MaxValue = 100000000000,
                Precision = 10,
            });

            return attribs;
        }
    }
}
