---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: pixelart
layout: home
permalink: "/pixelart"
---




### *pixelart*



<div><br></div>
Pixelart!<br>
Most of it is platormer mockups because thats what I like<br><br>

<div class="gallery-grid">
  
  

{% assign image_files = site.static_files | where: "pixel", true %}
{% for myimage in image_files %}
  
<div class="photo">
    <div class="img ">
      <img class="imgREAL myImg" src="{{ myimage.path }}" alt="{{myimage.basename}}"/>
    </div>
	<div class="imgText imgOneline">
	  {{myimage.basename}}<br />
	</div>
</div>
  
{% endfor %}



