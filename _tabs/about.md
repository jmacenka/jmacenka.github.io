---
# the default layout is 'page'
icon: fas fa-info-circle
order: 4
---

![Wellcome](https://www.seekpng.com/png/full/4-48714_pics-of-welcome-5380843775-welcome-png.png){: .light w="700" }
![Wellcome](https://harihutan.id/wp-content/uploads/revslider/welcome.png){: .dark w="700" }
# Wellcome to the Knowledge base of Jan Macenka

Here you will find a collection of [Tutorials](/categories/tutorial/), [Descriptions](/categories/descriptions/), [Scripts&Snippets](/categorie/scripts-and-snippets), best practices and more for the realms of IT and IT/OT convergence aswell as home-labing fun.

For the chance that you do not know me and wonder what Jan micht actually be doing, feel free to [check out my Homepage](https://www.macenka.de) which sould give some ideas.

This Page is built utilizing [Chirpy Jekyll Theme](https://github.com/cotes2020/jekyll-theme-chirpy#chirpy-jekyll-theme) and was inspired by the work from [Techno Tim](https://www.youtube.com/@TechnoTim) who even made this installation guide that I followed. Cudos for the great work.

Feel free to comment and reach out shoud you have questions or suggestions, especially if this helpfull to you.
Should you feel even more generous, you can feel free to [send me a <i class="fas fa-coffee"></i>](https://ko-fi.com/macenkaj).

Best Regards,

[*Jan Macenka*](mailto:jan@macenka.de?subject=Question%20regarding%20knowledge.macenka.de&body=Hi%20Jan%2C%0D%0A%0D%0AI%20have%20the%20following%20question%2Fsuggestion%2Fcomplaint%20regarding%20knowledge.macenka.de%0D%0A%0D%0Axxx%0D%0A%0D%0ABest%20regards%2C%0D%0A%3CYOUR%20NAME%20GOES%20HERE%3E)

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>