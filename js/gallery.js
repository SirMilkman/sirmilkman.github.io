
const lightbox = document.getElementById("lightbox")
const lightboxImg = document.getElementById("lightbox-image")
const lbText = document.getElementById("imgText")

const images = document.querySelectorAll('screenshots.screenshot')
images.forEach(image => {
    image.addEventListener('click', e => {
        lightbox.classList.add('active')
        lightboxImg.src = image.src
    })
})

lightbox.addEventListener('click', e => {
    
    lightbox.classList.remove('active')
})