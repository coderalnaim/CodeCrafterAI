# Main Python script for the app
import flet as ft
import openai
import subprocess
import tempfile
import os

# Set your OpenAI API key here
OPENAI_API_KEY = input('Please Enter Your OpenAI API Key:\n')
openai.api_key = OPENAI_API_KEY

def generate_code_and_explanation(prompt, model="gpt-3.5-turbo", max_tokens=300):
    response = openai.ChatCompletion.create(
        model=model,
        messages=[{"role": "user", "content": f"Generate Python code for: {prompt}. Then explain it briefly in plain text."}],
        max_tokens=max_tokens,
        temperature=0.3,
    )
    generated_text = response.choices[0].message["content"].strip()

    # Initialize variables
    code_section = ""
    explanation_section = ""

    # Enhanced logic to handle code blocks and plain text explanations
    code_start = generated_text.find("```python")
    if code_start == -1:
        code_start = generated_text.find("```")

    if code_start != -1:
        # If code blocks are detected
        code_start += len("```python") if "```python" in generated_text else len("```")
        code_end = generated_text.find("```", code_start)
        if code_end != -1:
            code_section = generated_text[code_start:code_end].strip()
            explanation_section = generated_text[code_end + len("```"):].strip()
        else:
            explanation_section = generated_text
    else:
        # Fallback: Handle inline explanations with code interspersed
        code_blocks = []
        in_code_block = False
        explanation_lines = []
        for line in generated_text.splitlines():
            if line.strip().startswith("```"):
                in_code_block = not in_code_block
                continue
            if in_code_block:
                code_blocks.append(line)
            else:
                explanation_lines.append(line)

        code_section = "\n".join(code_blocks).strip()
        explanation_section = "\n".join(explanation_lines).strip()

    # If no explicit code block is detected, fallback to the old behavior
    if not code_section:
        lines = generated_text.splitlines()
        code_lines = []
        explanation_lines = []
        code_mode = True

        for line in lines:
            if code_mode and (
                line.strip().startswith("In the improved code")
                or line.strip().startswith("# Explanation")
                or line.strip().startswith("Explanation")
                or line.strip().startswith("In summary")
            ):
                code_mode = False
            if code_mode:
                code_lines.append(line)
            else:
                explanation_lines.append(line)

        code_section = "\n".join(code_lines).strip()
        explanation_section = "\n".join(explanation_lines).strip()

    return code_section, explanation_section


def main(page: ft.Page):
    page.title = "Generative AI IDE"
    page.theme_mode = "dark"
    page.padding = 20
    page.bgcolor = "#1e1e1e"

    # Sidebar for file navigation
    file_label = ft.Text("main.py", size=16, color="lightgray")

    sidebar = ft.Container(
        content=ft.Column(
            [
                ft.Text("GenAi", size=18, color="white", weight="bold"),
                file_label,
            ],
            spacing=10,
            alignment="start"
        ),
        width=200,
        bgcolor="#2d2d2d",
        padding=10,
        border_radius=ft.border_radius.all(5),
    )

    # Prompt input for code generation
    prompt_input = ft.TextField(
        hint_text="Describe the code you want generated...",
        expand=True,
        height=50,
        bgcolor="#2d2d2d",
        color="white",
        text_style=ft.TextStyle(color="lightgray"),
    )
    prompt_button = ft.ElevatedButton(
        "Generate Code", on_click=lambda e: handle_prompt(), icon=ft.icons.CODE, bgcolor="#337ab7", color="white"
    )

    # Input for code improvement
    improve_input = ft.TextField(
        hint_text="Paste code here to improve...",
        expand=True,
        height=50,
        bgcolor="#2d2d2d",
        color="white",
        text_style=ft.TextStyle(color="lightgray"),
    )
    improve_button = ft.ElevatedButton(
        "Improve Code", on_click=lambda e: improve_code(), icon=ft.icons.BOLT, bgcolor="#f0ad4e", color="white"
    )

    # Main code editor area
    code_editor = ft.TextField(
        multiline=True,
        height=400,
        expand=True,
        text_style=ft.TextStyle(size=14, font_family="monospace"),
        hint_text="Generated code will appear here...",
        bgcolor="#1c1c1c",
        border_radius=ft.border_radius.all(5),
    )

    # Explanation area with reduced width
    explanation_area = ft.TextField(
        label="Explanation",
        multiline=True,
        height=400,
        width=300,
        read_only=True,
        text_style=ft.TextStyle(size=14, color="lightgray", font_family="monospace"),
        bgcolor="#2d2d2d",
        border_radius=ft.border_radius.all(5),
    )

    # Terminal output section to display code execution results
    terminal_output = ft.TextField(
        label="Terminal Output",
        multiline=True,
        height=200,
        expand=True,
        read_only=True,
        text_style=ft.TextStyle(size=14, color="lightgray", font_family="monospace"),
        hint_text="Code execution results will appear here...",
        bgcolor="#1c1c1c",
        border_radius=ft.border_radius.all(5),
    )

    # Initialize Flet FilePicker for Save functionality
    def save_file_result(e: ft.FilePickerResultEvent):
        if e.path:
            file_name = e.path.split("\\")[-1]
            if ".py" in file_name:
                save_file_path.value = file_name
            else:
                save_file_path.value = file_name + ".py"
        else:
            save_file_path.value = "Cancelled!"

        with open(save_file_path.value, "w") as file:
            code_value = code_editor.value
            file.write(code_value)

        print(save_file_path.value)
        
        file_label.value = save_file_path.value.split("/")[-1]# Update the label with the new file name
        page.update()

    save_file_dialog = ft.FilePicker(on_result=save_file_result)
    save_file_path = ft.Text()
    page.overlay.append(save_file_dialog)

    # Function to handle code generation prompt
    def handle_prompt():
        prompt_text = prompt_input.value
        generated_code, explanation = generate_code_and_explanation(prompt_text)
        code_editor.value = generated_code
        explanation_area.value = explanation
        page.update()

    # Function to run code and display output
    def run_code():
        with tempfile.NamedTemporaryFile(delete=False, suffix=".py") as temp_file:
            temp_file.write(code_editor.value.encode('utf-8'))
            temp_file_path = temp_file.name
        result = subprocess.run(
            ["python", temp_file_path],
            capture_output=True,
            text=True
        )
        terminal_output.value = result.stdout if result.stdout else result.stderr
        page.update()

    # Function to improve code and display updated code
    def improve_code():
        selected_text = improve_input.value
        if selected_text:
            prompt = f"Improve the following code:\n{selected_text}"
            improved_code, explanation = generate_code_and_explanation(prompt)
            code_editor.value += f"\n# Improved code:\n{improved_code}\n"
            explanation_area.value = explanation
            improve_input.value = ""
        page.update()

    # Implementing new file selection functionality
    def select_file(e: ft.FilePickerResultEvent):
        page.add(filepicker)
        filepicker.pick_files("Select file...")

    def return_file(e: ft.FilePickerResultEvent): 
        with open(e.files[0].path, "r") as file:
            code_value = file.read()
            code_editor.value = code_value
        file_label.value = e.files[0].name  # Update the label with the new file name
        page.update()

    # Adding the file selection and file path display components beside the save button
    filepicker = ft.FilePicker(on_result=return_file)
    page.overlay.append(filepicker)

    save_button = ft.ElevatedButton(
        "Save File", on_click=lambda e: save_file_dialog.save_file(
                        "Select py file...",
                        file_name="main.py",
                        file_type= ft.FilePickerFileType.CUSTOM,
                        allowed_extensions=["py"]
                    ), icon=ft.icons.SAVE, bgcolor="#5bc0de", color="white"
    )

    select_file_button = ft.ElevatedButton(
        "Select File", on_click=lambda e: select_file(e),
        icon=ft.icons.FOLDER_OPEN, bgcolor="#337ab7", color="white"
    )

    # Organizing layout with better spacing and alignment
    page.add(
        ft.Row(
            [
                sidebar,
                ft.VerticalDivider(color="gray"),
                ft.Column(
                    [
                        ft.ResponsiveRow([prompt_input, prompt_button], vertical_alignment="center", spacing=10),
                        ft.ResponsiveRow([improve_input, improve_button], vertical_alignment="center", spacing=10),
                        ft.Container(content=code_editor, padding=10),
                        ft.Row(
                            [
                                select_file_button,
                                save_button,
                                ft.ElevatedButton("Run Code", on_click=lambda e: run_code(), icon=ft.icons.PLAY_ARROW, bgcolor="#5cb85c", color="white"),
                            ],
                            alignment="center",
                            spacing=10,
                        ),
                        terminal_output,
                    ],
                    spacing=20,
                    expand=True,
                ),
                ft.VerticalDivider(color="gray"),
                explanation_area,
            ],
            spacing=20,
            expand=True,
        )
    )

# Run the Flet app
ft.app(target=main)
