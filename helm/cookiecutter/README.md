# Cookiecutter Chart Generator

## Overview

Cookiecutter Chart Generator is a tool for rapidly generating Helm chart templates for Kubernetes projects. It streamlines the process of setting up the basic structure of a Helm chart, allowing users to focus more on custom configurations rather than boilerplate code.

## Usage

To use Cookiecutter Chart Generator, follow these steps:

1. Ensure you have Python installed on your system.
2. Install Cookiecutter:

    ```bash
    pip install cookiecutter certifi
    ```

3. Generate a Helm chart using Cookiecutter:

    ```bash
    cd aip/aip-spark
    cookiecutter cookiecutter
    ```

4. Follow the prompts to customize your chart (e.g., repository name).

5. Once the prompts are completed, your Helm chart will be generated based on the provided configurations.
