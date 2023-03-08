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
    internal class Table1Attribs
    {
        public static List<AttributeMetadata> getAttribs()
        {
            var attribs = new List<AttributeMetadata>();

            /**
             * Meta
             * */
            attribs.Add(new StringAttributeMetadata
            {
                SchemaName = "prefix_columnname",
                LogicalName = "prefix_columnname",
                DisplayName = new Label("Column Displayname", 1044),
                RequiredLevel = new AttributeRequiredLevelManagedProperty(AttributeRequiredLevel.ApplicationRequired),
                Description = new Label("Some description", 1044),
                MaxLength = 10
            });

            return attribs;
        }
    }
}
