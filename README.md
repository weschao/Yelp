### Yelp 

This is a Yelp app displaying search results using the OAuth 1.0a [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api). 

Time spent: 8h

### Features

#### Required

 * Search results page
- [x] Table rows should be dynamic height according to the content height
- [x] Custom cells should have the proper Auto Layout constraints
- [x] Search bar should be in the navigation bar
 * Filter page
- [x] Implement filters for category, sort (best match, distance, highest rated), distance (miles), deals (on/off).
- [x] Filters table should be organized into sections as in the mock.
- [x] Radius filter should expand as in the real Yelp app
- [x] Categories should show a subset of the full list with a "See All" row to expand. 
- [x] Clicking on the "Apply" button should dismiss the filters page and trigger the search w/ the new filter settings.

Settings page needs to remember current settings

#### Optional

- [ ] Infinite scroll for restaurant results
- [ ] Implement map view of restaurant results
- [ ] Search bar expands to show location like the real Yelp app
- [ ] Implement a custom switch
- [ ] Implement the restaurant detail page
- [ ] push cell logic into the custom cell instead of in the main viewcontroller

### Walkthrough
![Video Walkthrough](http://i.imgur.com/4pDzo12.gifv)

Credits
---------
* [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)