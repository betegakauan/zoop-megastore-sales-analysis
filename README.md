# ZOOP Megastore - Q1 Sales and Customer Analysis

End-to-end data analysis for a fictional e-commerce company, **ZOOP Megastore**: from raw CSV files to a strategic dashboard and a data-backed recommendation for the next semester.

> **Business question:** where should we focus marketing and inventory efforts to maximize profit and customer satisfaction?

## Dashboard

**Live dashboard:** [Tableau](https://public.tableau.com/views/ZOOPMegastore-Q12023GeographicandCustomerAnalysis/StrategicDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


## Key findings

| Metric | Result |
|---|---|
| Q1 revenue | R$ 810,828.88 (120 sales, 291 units) |
| Monthly revenue | Jan R$ 234,634.61 / Feb R$ 282,351.34 / Mar R$ 293,842.93 |
| Top category | Peripherals, 38.0% of revenue (leads in 7 of 10 states) |
| Top 3 states | SC, RS and GO: 48% of revenue |
| Top 5 products | 46% of revenue; Mesa Digitalizadora alone is 15% |
| Avg revenue per customer | ZOOP Prime R$ 14,255.06 vs non-subscribers R$ 19,900.10 |

**Top 5 products by revenue**

| # | Product | Revenue |
|---|---|---|
| 1 | Mesa Digitalizadora | R$ 121,141.96 |
| 2 | Notebook Gamer | R$ 78,082.44 |
| 3 | Luminária de Mesa LED | R$ 61,397.75 |
| 4 | Mouse Gamer Sem Fio | R$ 58,387.27 |
| 5 | Livro: A Guerra dos Tronos | R$ 56,314.76 |

**Top 5 states by revenue**

| State | Revenue | Share |
|---|---|---|
| SC | R$ 168,706.83 | 20.8% |
| RS | R$ 116,725.10 | 14.4% |
| GO | R$ 105,814.18 | 13.1% |
| RJ | R$ 93,077.93 | 11.5% |
| SP | R$ 81,039.65 | 10.0% |

## Recommendation

Prioritize **Peripherals**: concentrate marketing and inventory on this category, starting with **SC, RS and GO**, and make sure the 5 products that drive 46% of revenue stay available. In March, revenue grew only 4% and Peripherals dropped 22% from February.

Do **not** launch a Prime conversion campaign for now: Prime subscribers spend about 28% less per customer than non-subscribers. The sample is small (15 vs 30 buyers), so review the program's costs and benefits before expanding it.

Full reasoning, evidence and limitations: [`reports/recommendations.md`](reports/recommendations.md).

## Project stages

| Stage | Goal | Tools | Where |
|---|---|---|---|
| 1. Exploration and cleaning | Revenue by month and category, data quality checks | Python, Pandas, Matplotlib | [`analysis/`](analysis/) |
| 2. Database | Relational model (`customers`, `sales`), top products and customers, Prime vs non-Prime | SQLite (SQL) | [`database/`](database/) |
| 3. Geographic and customer analysis | Revenue by state and category, Prime filter | Tableau Public | [`dashboard/`](dashboard/) |
| 4. Strategic dashboard | Story and recommendation for the board | Tableau Public | [`dashboard/`](dashboard/) |

## Data

Two fictional tables provided with the project brief (`data/raw/`):

- `clientes.csv`: 50 customers (`id_cliente`, `nome_cliente`, `email`, `estado`, `plano_assinatura`)
- `vendas.csv`: 120 sales from 2023-01-01 to 2023-03-30 (`id_venda`, `data_venda`, `id_cliente`, `id_produto`, `produto`, `categoria`, `valor_venda`, `quantidade`)

`data/processed/` holds the English-named versions used by the database and by Tableau (`customers.csv`, `sales.csv`). They add `state_name`, `country`, `latitude` and `longitude` to help the map. Category labels and subscription values (`Sim`/`Nao` -> `Yes`/`No`) were translated; product names were kept as in the source.

**Revenue definition:** `revenue = sale_value * quantity`, as set by the project brief.

## Limitations

- The data has **no cost, margin, stock or satisfaction fields**. "Most profitable" therefore means "highest revenue", and the inventory recommendation is about prioritizing availability, not about current stock levels.
- Small sample (120 sales, 50 customers). Differences between small groups, such as Prime vs non-Prime (p around 0.05-0.07) and states with few customers, are signals to investigate, not conclusions.
- Unit prices in the source are inconsistent for the same product, so `sale_value` could also be read as the sale total. Under that reading the category ranking does not change, but the 3rd product in the Top 5 does.
- 2 customers share the same name and email (IDs 127 and 132, in different states). They were kept as separate customers.
- SQLite was used instead of MySQL, and Tableau Public instead of Power BI (macOS has no native Power BI Desktop).

## How to reproduce

```bash
git clone <your-repository-url>
cd zoop-megastore-sales-analysis
pip install -r requirements.txt
python analysis/stage1_sales_exploration.py 
```

- **Database:** build it with `sqlite3 zoop_megastore.db < database/sql/zoop_sqlite_01_create_and_load.sql`, then run the queries in `database/sql/zoop_sqlite_02_queries.sql`.
- **Dashboard:** in Tableau Public, connect to `data/processed/customers.csv` and `data/processed/sales.csv` and relate them by `customer_id`.

## Repository structure

```
zoop-megastore-sales-analysis/
├── README.md
├── requirements.txt
├── data/
│   ├── raw/                  original CSV files
│   └── processed/            English-named CSVs used by SQLite and Tableau
├── analysis/                 Stage 1: exploration and cleaning
├── database/
│   ├── zoop_megastore.db     ready-to-open SQLite database
│   └── sql/                  create/load scripts and analysis queries
├── reports/
│   ├── recommendations.md    findings and strategic recommendation
│   └── figures/              charts from Stage 1
└── dashboard/                screenshot and link to the Tableau dashboard
```

## Author

Kauan Betega
[linkedin/kauanbetega](https://www.linkedin.com/in/kauanbetega/)
