// This is a C# script used in Tabular Editor to create or update DAX Measures

// Function to create or update a measure with fixed table name and format string

  

// NB! If the table 'Måltall' does not exist in your semantic modell, you have to create it in Power BI Desktop before you run this script. After you have run the script. Remeber to delete the empty column to convert to a measure table.

  

void CreateOrUpdateMeasure(string measureName, string expression, string formatString = "#,0")

{

var table = Model.Tables\["Måltall"\];

Measure measure = table.Measures.Contains(measureName)

? table.Measures\[measureName\]

: table.AddMeasure(measureName);

measure.Expression = expression;

measure.FormatString = formatString; // Use the provided format string

CreateOrUpdateLastYearMeasure(measure); // Create or update the corresponding "Last Year" measure

CreateOrUpdateHIÅMeasure(measure); // Create or update the corresponding "Year To Date" measure

CreateOrUpdateHIÅIFjorMeasure(measure); // Create or update the corresponding "Year To Date Last Year" measure

CreateOrUpdateR12Measure(measure); // Create or update the corresponding "R12" measure

CreateOrUpdateHittilIProsjektMeasure(measure); // Create or update the corresponding "Hittil i prosjekt" measure

}

// Function to create or update a "Last Year" measure

void CreateOrUpdateLastYearMeasure(Measure measure)

{

string lastYearMeasureName = measure.Name + " i fjor";

string lastYearExpression = "CALCULATE(\[" + measure.Name + "\], SAMEPERIODLASTYEAR('Kalender'\[Dato\]))";

string lastYearFormatString = measure.FormatString;

Measure lastYearMeasure = measure.Table.Measures.Contains(lastYearMeasureName)

? measure.Table.Measures\[lastYearMeasureName\]

: measure.Table.AddMeasure(lastYearMeasureName);

lastYearMeasure.Expression = lastYearExpression;

lastYearMeasure.FormatString = lastYearFormatString;

lastYearMeasure.DisplayFolder = "' I fjor";

}

  

// Function to create or update a "Year To Date" measure

void CreateOrUpdateHIÅMeasure(Measure measure)

{

string hiåMeasureName = measure.Name + " HIÅ";

string hiåExpression = "CALCULATE(\[" + measure.Name + "\], DATESYTD( 'Kalender'\[Dato\] ) )";

string hiåFormatString = measure.FormatString;

Measure hiåMeasure = measure.Table.Measures.Contains(hiåMeasureName)

? measure.Table.Measures\[hiåMeasureName\]

: measure.Table.AddMeasure(hiåMeasureName);

hiåMeasure.Expression = hiåExpression;

hiåMeasure.FormatString = hiåFormatString;

hiåMeasure.DisplayFolder = "' HIÅ";

}

  

// Function to create or update a "Year To Date Last Year" measure

void CreateOrUpdateHIÅIFjorMeasure(Measure measure)

{

string hiåIFjorMeasureName = measure.Name + " HIÅ i fjor";

string hiåIFjorExpression = "CALCULATE(\[" + measure.Name + "\], SAMEPERIODLASTYEAR( DATESYTD( Kalender\[Dato\] ) ) )";

string hiåIFjorFormatString = measure.FormatString;

Measure hiåIFjorMeasure = measure.Table.Measures.Contains(hiåIFjorMeasureName)

? measure.Table.Measures\[hiåIFjorMeasureName\]

: measure.Table.AddMeasure(hiåIFjorMeasureName);

hiåIFjorMeasure.Expression = hiåIFjorExpression;

hiåIFjorMeasure.FormatString = hiåIFjorFormatString;

hiåIFjorMeasure.DisplayFolder = "' HIÅ i fjor";

}

  

// Function to create or update a "R12" measure

void CreateOrUpdateR12Measure(Measure measure)

{

string r12MeasureName = measure.Name + " R12";

string r12Expression = "CALCULATE(\[" + measure.Name + "\], DATESINPERIOD( ( Kalender\[Dato\] ), LASTDATE( Kalender\[Dato\] ), -1, YEAR ) )";

string r12FormatString = measure.FormatString;

Measure r12Measure = measure.Table.Measures.Contains(r12MeasureName)

? measure.Table.Measures\[r12MeasureName\]

: measure.Table.AddMeasure(r12MeasureName);

r12Measure.Expression = r12Expression;

r12Measure.FormatString = r12FormatString;

r12Measure.DisplayFolder = "' R12";

}

  

// Function to create or update a "Hittil i prosjekt" measure

void CreateOrUpdateHittilIProsjektMeasure(Measure measure)

{

string hipMeasureName = measure.Name + " hittil i prosjekt";

string hipExpression = "CALCULATE(\[" + measure.Name + "\], ALL( Kalender\[Dato\] ), Kalender\[Dato\] <= MAX( ( Kalender\[Dato\] ) ) )";

string hipFormatString = measure.FormatString;

Measure hipMeasure = measure.Table.Measures.Contains(hipMeasureName)

? measure.Table.Measures\[hipMeasureName\]

: measure.Table.AddMeasure(hipMeasureName);

hipMeasure.Expression = hipExpression;

hipMeasure.FormatString = hipFormatString;

hipMeasure.DisplayFolder = "' Hittil i prosjekt";

}

  
  

// Specific format string

  

// Hovedbok measures

CreateOrUpdateMeasure(

"Driftsmargin",

"DIVIDE( \[Driftsresultat\], \[Inntekt\], 0 )",

"#,0.0%;-#,0.0%;#,0.0%"

);

  
  

// Budsjett measures

CreateOrUpdateMeasure(

"Driftsmargin i budsjett",

"DIVIDE( \[Driftsresultat i budsjett\], \[Inntekt i budsjett\], 0 )",

"#,0.0%;-#,0.0%;#,0.0%" // Pass the specific format string for Driftsmargin

);

  
  

// Avvik mot budsjett measures

CreateOrUpdateMeasure(

"Avvik mot budsjett driftsmargin",

"CALCULATE( \[Driftsmargin\] - \[Driftsmargin i budsjett\] )",

"#,0.0%;-#,0.0%;#,0.0%"

);

  

// ... other measures ...

  

// Hovedbok measures

CreateOrUpdateMeasure(

"Annen driftsinntekt",

"CALCULATE( SUM( Hovedbok\[Beløp\] ), Kontoplan\[Kontogruppebeskrivelse\] = \\"Annen driftsinntekt\\" )"

);

CreateOrUpdateMeasure(

"Salgsinntekt",

"CALCULATE( SUM( Hovedbok\[Beløp\] ), Kontoplan\[Kontogruppebeskrivelse\] = \\"Salgsinntekt\\" )"

);

CreateOrUpdateMeasure(

"Inntekt",

"CALCULATE( \[Salgsinntekt\] + \[Annen driftsinntekt\] )"

);

CreateOrUpdateMeasure(

"Kostnad",

"VAR TargetDescriptions = { \\"Materiell, varer, leier\\", \\"Lønnskostnader\\", \\"Reparasjoner og vedlikehold\\", \\"Andre driftskostnader\\", \\"Avskrivninger\\" } \\nRETURN \\nCALCULATE( \\n SUM(Hovedbok\[Beløp\]), \\n Kontoplan\[Kontogruppebeskrivelse\] IN TargetDescriptions \\n)"

);

CreateOrUpdateMeasure(

"Driftsresultat",

"CALCULATE( \[Inntekt\] + \[Kostnad\] ) // Det benyttes pluss fordi inntekter er positive og kostnader er negative."

);

  
  

// Budsjett measures

CreateOrUpdateMeasure(

"Annen driftsinntekt i budsjett",

"CALCULATE( SUM( Budsjett\[Beløp\] ), Kontoplan\[Kontogruppebeskrivelse\] = \\"Annen driftsinntekt\\" )"

);

CreateOrUpdateMeasure(

"Salgsinntekt i budsjett",

"CALCULATE( SUM( Budsjett\[Beløp\] ), Kontoplan\[Kontogruppebeskrivelse\] = \\"Salgsinntekt\\" )"

);

CreateOrUpdateMeasure(

"Inntekt i budsjett",

"CALCULATE( \[Salgsinntekt i budsjett\] + \[Annen driftsinntekt i budsjett\] )"

);

CreateOrUpdateMeasure(

"Kostnad i budsjett",

"VAR TargetDescriptions = { \\"Materiell, varer, leier\\", \\"Lønnskostnader\\", \\"Reparasjoner og vedlikehold\\", \\"Andre driftskostnader\\", \\"Avskrivninger\\" } \\nRETURN \\nCALCULATE( \\n SUM(Budsjett\[Beløp\]), \\n Kontoplan\[Kontogruppebeskrivelse\] IN TargetDescriptions \\n)"

);

CreateOrUpdateMeasure(

"Driftsresultat i budsjett",

"CALCULATE( \[Inntekt i budsjett\] + \[Kostnad i budsjett\] ) // Det benyttes plus fordi inntekter er positive og kostnader er negative"

);

  

// Avvik mot budsjett measures

CreateOrUpdateMeasure(

"Avvik mot budsjett inntekt",

"CALCULATE( \[Inntekt\] - \[Inntekt i budsjett\] )"

);

  

CreateOrUpdateMeasure(

"Avvik mot budsjett kostnad",

"CALCULATE( \[Kostnad\] - \[Kostnad i budsjett\] )"

);

  

CreateOrUpdateMeasure(

"Avvik mot budsjett driftsresultat",

"CALCULATE( \[Driftsresultat\] - \[Driftsresultat i budsjett\] )"

);

  
  

// Hide columns

Model.Tables\["Hovedbok"\].Columns\["Beløp"\].IsHidden = true;

Model.Tables\["Budsjett"\].Columns\["Beløp"\].IsHidden = true;

  

// Format DAX

Model.AllMeasures.FormatDax();