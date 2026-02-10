// Get the modal, modal image, and caption
var modal = document.getElementById("myModal");
var modalImg = document.getElementById("img01");
var captionText = document.getElementById("caption");

// Get all images with a specific class
var images = document.querySelectorAll(".myImg");

// Open modal when image clicked
images.forEach(function(img) {
  img.addEventListener("click", function(e) {
    modal.style.display = "block";
    modalImg.src = this.src;
    captionText.innerHTML = this.alt;
  });
});

// Close modal when clicking outside the image
modal.addEventListener("click", function () {
  modal.style.display = "none";
  console.log("HI")
});

// Prevent clicks on the image from closing the modal
modalImg.addEventListener("click", function (e) {
  e.stopPropagation();
});

