
const lightbox = document.getElementById("lightbox")
const lightboxImg = document.getElementById("lightbox-image")
const lbText = document.getElementById("imgText")

const images = document.querySelectorAll('imgREAL')
images.forEach(image => {
    image.style.width=500px;
    image.addEventListener('click', e => {
        lightbox.classList.add('active')
        lightboxImg.src = image.src
    })
})

lightbox.addEventListener('click', e => {
    
    lightbox.classList.remove('active')
})