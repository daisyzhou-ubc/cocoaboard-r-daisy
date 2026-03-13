# CocoaBoard (R) 

A simplified R Shiny re-implementation of the [CocoaBoard](https://github.com/UBC-MDS/DSCI-532_2026_8_cocoaboard) dashboard, originally built in Python Shiny for DSCI 532. This individual version recreates the core functionality — filtering chocolate sales data by country and product, displaying KPI summaries, a monthly revenue trend chart, and a salesperson leaderboard — using R and the `bslib` layout framework.

## Dataset

The dashboard uses the [Chocolate Sales](https://www.kaggle.com/datasets/atharvasoundankar/chocolate-sales) dataset from Kaggle. The CSV file should be placed at `data/Chocolate_Sales.csv`.

## Installation & Running Locally

### Prerequisites

-   **R** (\>= 4.1)
-   The following R packages: `shiny`, `bslib`, `tidyverse`, `ggplot2`, `scales`

### Install packages

Open an R console (type 'R' in the terminal and enter) and run:

``` r
install.packages(c("shiny", "bslib", "tidyverse", "ggplot2", "scales", "rsconnect"))
```

### Run the app

From the project root directory, open an R console and run:

``` r
shiny::runApp()
```

Or, if using RStudio, open `app.R` and click the **Run App** button.

### Generate the dependency file for deployment

Before deploying to Posit Connect Cloud, generate `manifest.json`:

``` r
rsconnect::writeManifest()
```

## Deployment

The app is deployed on Posit Connect Cloud.

🔗 **Live app:** https://connect.posit.cloud/daisy-littlemonster/content/019ce988-a69a-df89-053f-873ba813d216

## Repository Setup (from scratch)

If you are setting up this project from scratch:

1.  **Create a new public GitHub repository** on [GitHub](https://github.com/new).

2.  **Clone the repo locally:**

    ``` bash
    git clone https://github.com/<your-username>/<your-repo-name>.git
    cd <your-repo-name>
    ```

3.  **Add the project files** (`app.R`, `data/Chocolate_Sales.csv`, `README.md`).

4.  **Generate `manifest.json`** by running `rsconnect::writeManifest()` in R from the project root.

5.  **Commit and push:**

    ``` bash
    git add .
    git commit -m "Initial commit"
    git push origin main
    ```

6.  **Deploy to Posit Connect Cloud:**

    -   Sign in at [connect.posit.cloud](https://connect.posit.cloud/).
    -   Click the **Publish** icon → select **Shiny**.
    -   Select your public GitHub repository and branch.
    -   Set `app.R` as the primary file.
    -   Click **Publish**.

7.  **Add the deployed URL** to the repo's **About** section on GitHub (gear icon on the repo page → Website field).

## License

MIT