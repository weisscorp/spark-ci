from cookiecutter.utils import simple_filter

@simple_filter
def multiple_choice_filter(value):
    if isinstance(value, str):
        options = value.split(', ')
    elif isinstance(value, list):
        options = value
    else:
        raise ValueError("Input must be a string or a list")
    readable_options = '\n'.join([f"{i+1} - {option}" for i, option in enumerate(options)])
    selected_indices_str = input(f"Choose options by entering comma-separated:\n{readable_options}\nEnter, eg \"1,2\": ")
    selected_indices = [int(index.strip()) for index in selected_indices_str.split(',')]
    selected_options = [options[index - 1] for index in selected_indices]
    return ','.join(selected_options)
