---
title: "Dbt's Semantic Layers for Dummies"
author: Andreas Lien
date: 2024-04-19T19:54:12+02:00
draft: false
toc: false
cover: /media/semantic_layers.jpg
tags:
  - dbt
  - sematic layers
  - dummies
---
👋 Hey there, Andreas here! I just finished an informative dummies post about dbt! 😄 In today's fast-paced world, understanding how to effectively manage and utilize dbt within an organization can be crucial for data professionals and enthusiasts alike. In this edition of my DBT series, I'll be diving into the intricacies of `model_groups` and `model_access` in dbt.

### Model Groups in dbt
In dbt, you can group models together under a key called `model_groups`. This is useful for organizing your data models by business domain or folder structure. You can define these groups in a `groups.yml` file at the root of your `models` directory. Here's how you can define and apply model groups:

```yaml
groups:
  finance:
    owner@example.com
  groups:
  operations:
    owner@example2.com
models:
  marts.finance:
    +group: finance
```

In the `dbt_project.yml` file, you can apply these model groups to specific models or folders:

```yaml
models:
  marts:
    finance:
      +group: finance
```

### Model Access in dbt
After defining your model groups, you might want to control the access of these groups. In dbt, by default, a model group is set to `protected` access level, which means that other models within the same project can reference (material) or depend on (depend) these models. However, if you have a model that is not yet fully baked and you don't want any other models in your project or across to it to rely on it, you can set its access level to `private`:

```yaml
models/my_model.sql:
  {{
    dbt_model: my_model,
    access: private
  }}
```

If your model is mature and ready for other projects or groups to use it, you can set its access level to `protected` or even `public`:

```yaml
models/my_mature_model.sql:
  {{
    dbt_model: my_mature_model,
    access: protected
  }}
```

### Mixing Model Access Levels in dbt
You can also mix different levels of model access within the same group by specifying them directly in the model's YAML or even in the SQL itself:

```yaml
models/my_model.yml:
  +access: private
```

```sql
models/my_model.sql:
  {{
    dbset access: private
    select * from my_dependent_model
    select ** from my_independent_model
  }}
```

### Conclusion
In this post, we've covered how to define and apply model groups in dbt, as well as how to control the access of these models. Remember that the most specific config will always win, so be sure to consider that when setting up your model access levels. Stay tuned for more DBT series posts coming soon! And if you're enjoying my non-dbt related writings, I'm genuinely touched by your support and engagement. Don't forget to subscribe, share with your network, or however else you choose to follow along this journey with me. Thanks for stopping by! Have a great day, and I'll catch you on the next one! 👋✨