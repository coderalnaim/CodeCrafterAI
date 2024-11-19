
# Generative AI IDE

A Python-based application for generating, improving, and running Python code with explanations using OpenAI's GPT models. Built with **Flet** for a user-friendly UI.

---

## **Features**

- **Code Generation**: Create Python code snippets from plain text prompts.
- **Code Improvement**: Optimize existing Python code.
- **Code Execution**: Run Python code directly in the app and see the terminal output.
- **Save and Load Files**: Manage files with a simple UI.
- **Code Explanation**: Receive clear explanations for generated code.

---

## **Setup and Installation**

### **Prerequisites**
1. Python 3.8 or higher installed.
2. A valid OpenAI API key.

---

### **Step-by-Step Instructions**

#### **1. Clone the Repository**
   ```bash
   git clone https://github.com/coderalnaim/CodeCrafterAI.git
   cd CodeCrafterAI
   ```

#### **2. Set Up the Environment**
Run the setup script to create a virtual environment and install dependencies:

   ```bash
   bash setup.sh
   ```

#### **3. Start the Application**
Launch the app by running the `run.sh` script:

   ```bash
   bash run.sh
   ```

#### **4. Input Your API Key**
When prompted, enter your OpenAI API key. The key will be stored temporarily as an environment variable for the current session.

---

## **How to Use**

1. **Code Generation**:
   - Describe your desired Python code in the input field.
   - Click the **"Generate Code"** button to generate code.
   
2. **Code Improvement**:
   - Paste your existing Python code in the input field.
   - Click the **"Improve Code"** button for optimization.

3. **Run Python Code**:
   - Click **"Run Code"** to execute the generated or improved code.
   - View the output in the **Terminal Output** section.

4. **Save and Load Python Files**:
   - Use the **Save** and **Select File** buttons to manage files.

---

## **File Structure**

```plaintext
GenerativeAI_IDE/
├── app/                  # Main application folder
│   ├── __init__.py       # Empty file for module initialization
│   ├── main.py           # Main Python script for the app
├── README.md             # Project documentation
├── requirements.txt      # Python dependencies
├── setup.sh              # Shell script to set up the environment
├── run.sh                # Shell script to run the application
├── .gitignore            # Files to ignore in Git
```

---

## **Troubleshooting**

If you encounter any issues during installation or while running the app, check the following:

1. **Python Version**:
   - Ensure you have Python 3.8 or higher installed.
   - Check your Python version by running:
     ```bash
     python --version
     ```

2. **Virtual Environment**:
   - If the virtual environment is not created or activated, manually create and activate it:
     ```bash
     python -m venv venv
     source venv/bin/activate  # On Windows: venv\Scripts\activate
     ```

3. **Dependency Issues**:
   - If dependencies are not installed properly, try reinstalling:
     ```bash
     pip install -r requirements.txt
     ```

4. **API Key Issues**:
   - Ensure your OpenAI API key is valid.
   - If you're unsure, regenerate your API key from the [OpenAI Dashboard](https://platform.openai.com/).

---

## **Important Note on API Key Storage**

- The OpenAI API key is stored as an **environment variable** for the current session only.
- You will need to re-enter the API key each time you restart the application or open a new terminal session.

---

## **License**

This project is licensed under the MIT License.
