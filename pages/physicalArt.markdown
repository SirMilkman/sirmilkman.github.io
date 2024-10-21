---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: art
layout: home
permalink: "/art"
---




### *physical art*



<div><br></div>
A collection of some of my physical artwork<br>
Mostly ink on paper!

<div class="gallery-grid">
  
  

{% assign image_files = site.static_files | where: "art", true %}
{% for myimage in image_files %}
  
<div class="photo">
    <div class="img ">
      <img class="imgREAL " src="{{ myimage.path }}" alt="{{myimage.name}}"/>
    </div>
	<div class="imgText imgOneline">
	  {{myimage.basename}}<br />
	</div>
</div>
  
{% endfor %}



