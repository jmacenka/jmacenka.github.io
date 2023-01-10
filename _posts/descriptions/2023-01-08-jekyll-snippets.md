---
# tutorial: https://chirpy.cotes.page/posts/write-a-new-post/
title: Jekyll Snippets
date: 2023-01-08 21:41:00 +0200
categories: [Scripts-and-Snippets]
tags: [blogging,markdown,jekyll,chirpy]     # TAG names should always be lowercase
authors: [jan]
#pin: true
#comments: false
render_with_liquid: false
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

### List of all usefull YAML flaggs or variables I found so far

```yaml
title: string
date: Timestamp in format TYYYY-MM-DD hh:mm:ss +/-nnnn
categories: [strings]
tags: [strings] # TAG names should always be lowercase
author: string
authors: [strings]
pin: bool
comments: bool
render_with_liquid: bool
mermaid: bool
math: bool
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

```liquid
{% link /assets/files/doc.pdf %}

{% link _posts/2016-07-26-name-of-post.md %}

[Link to a file]({% link /assets/files/doc.pdf %})

{% post_url /subdir/2010-07-21-name-of-post %}

[Name of Link]({% post_url 2010-07-21-name-of-post %})

```

can also be used with variables from the initial YAML Section

```yaml
---
title: My page
my_variable: footer_company_a.html
---
```

then in the post refecence them like

```liquid
{% link {{ page.my_variable }} %}
```

or just freely with global variables

```html
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
```

### Videos
Videos can be directly embeded into the blog like this

```liquid
{% include embed/{Platform}.html id='{ID}' %}
```

Where `Platform` is the lowercase of the platform name, and `ID` is the video ID.

The following table shows how to get the two parameters we need in a given video URL, and you can also know the currently supported video platforms.

| **Video URL**                                          | **Platform** | **ID**        |
|--------------------------------------------------------|--------------|---------------|
| https://www. **youtube** .com/watch?v= **H-B46URT4mg** | `youtube`    | `H-B46URT4mg` |
| https://www. **twitch** .tv/videos/ **1634779211**     | `twitch`     | `1634779211`  |

### Further reference

See also [the jekyll-guide on blog posts](https://jekyllrb.com/docs/posts/).

Best regards,
[_Jan Macenka_](https://www.macenka.de)