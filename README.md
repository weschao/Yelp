### Yelp 

This is a Yelp app displaying search results using the OAuth 1.0a [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api). 

Time spent: 4h30m

### Next steps

- Augment the search method in the `YelpClient` with whatever search parameters you want to support.

4:40

### Features

#### Required

 * Search results page
- [x] Table rows should be dynamic height according to the content height
- [x] Custom cells should have the proper Auto Layout constraints
- [x] Search bar should be in the navigation bar
 * Filter page
- [ ] Implement filters for category, sort (best match, distance, highest rated), distance (miles), deals (on/off).
- [x] Filters table should be organized into sections as in the mock.
- [x] Radius filter should expand as in the real Yelp app
- [ ] Categories should show a subset of the full list with a "See All" row to expand. 
- [ ] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

#### Optional

- [ ] Infinite scroll for restaurant results
- [ ] Implement map view of restaurant results
- [ ] Search bar expands to show location like the real Yelp app
- [ ] Implement a custom switch
- [ ] Implement the restaurant detail page
- [ ] push cell logic into the custom cell instead of in the main viewcontroller

### Walkthrough
![Video Walkthrough](http://i.imgur.com/tTrlVQ0.gif)

Credits
---------
* [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)