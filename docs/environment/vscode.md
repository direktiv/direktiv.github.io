# Setting Up Direktiv Workflow Validation in Visual Studio Code

For efficient management of Direktiv workflows outside our UI, we offer a schema validation using Direktiv's official schema and the Red Hat YAML extension in Visual Studio Code. This provides automatic validation and intellisense. Follow the guide below to set it up.

## Prerequisites:

- **Visual Studio Code**: Ensure that you have Visual Studio Code installed on your system.
- **Internet Connection**: This is essential for fetching the Direktiv schema.

## Step-by-step Guide:

### 1. Install the Red Hat YAML Extension

Begin by opening Visual Studio Code. Once it's up, navigate to the Extensions view by clicking on the `Extensions` icon on the Activity Bar situated on the side of the window. In the search bar, type `YAML` and then proceed to install the extension offered by Red Hat.

### 2. Modify the Settings

After the extension is installed, you'll need to add the Direktiv schema configuration. Here's how:

- Click on the gear icon found in the lower left corner of the Visual Studio Code window.
- From the dropdown that appears, select `Settings (JSON)`.

Within the settings JSON file that opens up, merge or add the following configuration:

```json
"yaml.schemas": {
  "https://raw.githubusercontent.com/direktiv/direktiv/stable/resources/direktiv.schema.json": ".wf.yaml"
}
```

### 3. Using the Schema Validation

From now on, each time you open a `.wf.yaml` file in Visual Studio Code, the program will apply the schema validations grounded on the Direktiv schema automatically. If the schema is not automatically applied or to make use of the schema validation when using simply `.yaml` as extension:

- Direct your attention to the lower right corner of the status bar, where you should find an option labeled "Select Language (YAML)" or something similar.
- Click on this option and from the dropdown list that appears, choose `direktiv-workflow`. This action will apply the schema.
