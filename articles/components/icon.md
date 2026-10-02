# Icon

Element provides a set of common icons.
[`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)
draws one by name; any component taking an `icon` takes its class,
`"el-icon-edit"`.

## Basic usage

``` r

tagList(
  el_icon("edit"), el_icon("share"), el_icon("delete"),
  el_button("search", "Search", type = "primary", icon = "el-icon-search"))
```

`el_icon(lib = "font-awesome")` draws a Font Awesome icon instead,
through the fontawesome package.

## Icons

Every icon Element ships, by the name
[`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)
takes:

``` r

css <- readLines(system.file("element-ui", "theme-chalk", "index.css",
                             package = "shiny.element"), warn = FALSE)
names <- unique(regmatches(css, gregexpr("(?<=\\.el-icon-)[a-z0-9-]+(?=:before)", css, perl = TRUE))[[1]])
tags$div(style = "display: flex; flex-wrap: wrap",
  lapply(sort(names), function(n) tags$div(
    style = "width: 120px; height: 90px; text-align: center; color: #606266; font-size: 12px",
    tags$i(class = paste0("el-icon-", n), style = "font-size: 24px; display: block; margin: 16px 0 8px"),
    n)))
```

add-location

aim

alarm-clock

apple

arrow-down

arrow-left

arrow-right

arrow-up

attract

back

bangzhu

bank-card

baseball

basketball

bell

bicycle

bottom

bottom-left

bottom-right

box

brush

burger

c-scale-to-original

camera

camera-solid

caret-bottom

caret-left

caret-right

caret-top

chat-dot-round

chat-dot-square

chat-line-round

chat-line-square

chat-round

chat-square

check

cherry

chicken

circle-check

circle-close

circle-plus

circle-plus-outline

close

close-notification

cloudy

cloudy-and-sunny

coffee

coffee-cup

coin

cold-drink

collection

collection-tag

connection

coordinate

copy-document

cpu

crop

d-arrow-left

d-arrow-right

d-caret

data-analysis

data-board

data-line

date

delete

delete-location

delete-solid

dessert

discount

discover

dish

dish-1

document

document-add

document-checked

document-copy

document-delete

document-remove

download

edit

edit-outline

eleme

error

female

files

film

finished

first-aid-kit

folder

folder-add

folder-checked

folder-delete

folder-opened

folder-remove

food

football

fork-spoon

full-screen

goblet

goblet-full

goblet-square

goblet-square-full

goods

grape

guide

headset

heavy-rain

help

hot-water

house

ice-cream

ice-cream-round

ice-cream-square

ice-drink

ice-tea

info

key

knife-fork

light-rain

lightning

link

loading

location

location-information

location-outline

lock

lollipop

magic-stick

male

map-location

medal

medal-1

menu

message

message-solid

mic

microphone

milk-tea

minus

mobile

mobile-phone

money

monitor

moon

moon-night

more

more-outline

mouse

news

no-smoking

notebook-1

notebook-2

odometer

office-building

open

orange

paperclip

partly-cloudy

pear

phone

phone-outline

picture

picture-outline

picture-outline-round

pie-chart

place

platform-eleme

plus

position

postcard

potato-strips

present

price-tag

printer

question

rank

reading

receiving

refresh

refresh-left

refresh-right

refrigerator

remove

remove-outline

right

s-check

s-claim

s-comment

s-cooperation

s-custom

s-data

s-finance

s-flag

s-fold

s-goods

s-grid

s-help

s-home

s-management

s-marketing

s-open

s-operation

s-opportunity

s-order

s-platform

s-promotion

s-release

s-shop

s-ticket

s-tools

s-unfold

school

scissors

search

sell

service

set-up

setting

share

ship

shopping-bag-1

shopping-bag-2

shopping-cart-1

shopping-cart-2

shopping-cart-full

smoking

soccer

sold-out

sort

sort-down

sort-up

star-off

star-on

stopwatch

success

sugar

suitcase

suitcase-1

sunny

sunrise

sunrise-1

sunset

switch-button

table-lamp

tableware

takeaway-box

thumb

tickets

time

timer

toilet-paper

top

top-left

top-right

trophy

trophy-1

truck

turn-off

turn-off-microphone

umbrella

unlock

upload

upload2

user

user-solid

video-camera

video-camera-solid

video-pause

video-play

view

wallet

warning

warning-outline

watch

watch-1

water-cup

watermelon

wind-power

zoom-in

zoom-out
