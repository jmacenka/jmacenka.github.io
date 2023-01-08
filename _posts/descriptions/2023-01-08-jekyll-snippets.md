---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: Jekyll Snippets
date: 2023-01-08 21:41:00 +0200
categories: [Scripts-and-Snippets]
tags: [blogging,markdown,jekyll,chirpy]     # TAG names should always be lowercase
authors: [jan]
#pin: true
comments: true
#mermaid: true
#math: true
---

![jekyll](/assets/img/logos/jekyll.png)
# Jekyll - The Documentation and Blogging System

This post will containt things I have learned and found usefull in connection with Jekyll and its Makrdown-Features.

References to files are described as relative path inside the Git-Repo of the project.

## Knowledge

* Posts can (and should) be organized in folder strucutres
* Jekyll uses [Liquid](https://shopify.github.io/liquid/) as its templating Engine which apparently behaves similar to Pythons [Jinja2](https://palletsprojects.com/p/jinja/)
* Tags should be all lowercase
* Diagrams and Graphs can be created with [Mermaid](https://github.com/mermaid-js/mermaid), requires the `mermaid: true` flag to be set in the posts initial YAML-Section
* Discussions and Comments are supportet e.g. via [giscus](https://giscus.app/) which needs to be configured in `_config.yml`{: .filepath}

## Snippets

### Minimal Setup

This needs to go in the `YAML` Section at the beginning of each post.

```yaml
---
title: TITLE
date: YYYY-MM-DD HH:MM:SS +0200
categories: [TOP_CATEGORIE, SUB_CATEGORIE]
tags: [TAG]     # TAG names should always be lowercase
#comments: false # deactivates comments, these are active by default
#math: true # loads mathematical library
#mermaid: true # loads a diagramm generating librarie
---
```

### Authors
Use the `_data/_authors.yaml`{: .filepath} file to list Authors which can be reffecenced by `<author_id>` in the blogs YAML-Section like 

```yaml
author: jan
# or
authors: [jan, andreas]
```

### Code-Blocks
Code-Blocks can be used with syntax highlighting like this

```shell
```shell
# content
    ```
{: file="path/to/file" }
```

### Liquid Codes
To use the templating engine use { variable } or {% expression %}

```yaml
{% link /assets/files/doc.pdf %}

{% link _posts/2016-07-26-name-of-post.md %}

[Link to a file]({% link /assets/files/doc.pdf %})

```

can also be used with variables from the initial YAML Section

```yaml
---
title: My page
my_variable: footer_company_a.html
---
```

```jinja
{% link {{ page.my_variable }} %}
```