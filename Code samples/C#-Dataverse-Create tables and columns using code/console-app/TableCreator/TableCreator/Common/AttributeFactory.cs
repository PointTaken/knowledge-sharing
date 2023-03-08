using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk.Metadata;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TableCreator
{
    public static class AttributeFactory
    {
        public static CreateAttributeRequest createAttribute<T>(T attributeMetadata, string entityName) where T : AttributeMetadata
        {
            return new CreateAttributeRequest
            {
                EntityName = entityName,
                Attribute = attributeMetadata
            };
        }

        public static UpdateAttributeRequest updateAttribute<T>(T attributeMetadata, string entityName) where T : AttributeMetadata
        {
            return new UpdateAttributeRequest
            {
                EntityName = entityName,
                Attribute = attributeMetadata,
                MergeLabels = false
            };
        }

    }
}
