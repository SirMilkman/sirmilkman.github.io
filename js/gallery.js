// Get the modal, modal image, and caption
var modal = document.getElementById("myModal");
var modalImg = document.getElementById("img01");
var captionText = document.getElementById("caption");

// Get all images with a specific class
var images = document.querySelectorAll(".myImg");

// Add a click event listener to each image
images.forEach(function(img) {
  img.addEventListener("click", function() {
    modal.style.display = "block";
    modalImg.src = this.src;
    captionText.innerHTML = this.alt;
  });
});

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// Close the modal when the user clicks on <span> (x)
span.onclick = function() {
  modal.style.display = "none";
};

