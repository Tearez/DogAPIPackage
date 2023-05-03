DogsLibrary README
==================

DogsLibrary is a library for fetching dog images from an API. This README provides an overview of how to use the public methods described in the code.


Instalation
-----

To install the package
1. Open Xcode
2. Select the project file
3. Select `Package Dependencies`
4. Paste `https://github.com/Tearez/DogAPIPackage.git` in the search field

Usage
-----

To use DogsLibrary in your project, first import it:

swiftCopy code

`import DogAPIPackage`

### Initialization

Create a new instance of DogsLibrary using the default initializer:

swiftCopy code

`let library = DogsLibrary()`

Alternatively, you can create an instance of DogsLibrary with a custom `ApiClientProtocol` implementation:

swiftCopy code

`let apiClient = MyApiClient() let library = DogsLibrary(apiClient: apiClient)`

### Fetching Images

#### Fetch a Single Image

To fetch a single dog image, call the `getImage()` method:

swiftCopy code

`do { let model = try await library.getImage() // Do something with the model } catch {// Handle error }`

The `getImage()` method returns a `LibraryModel` object that contains the URL of the fetched image.

#### Fetch Multiple Images

To fetch multiple dog images, call the `getImages(_:)` method and pass in the number of images to fetch:

swiftCopy code

`do { let models = try await library.getImages(5) // Do something with the models } catch { // Handle error }`

The `getImages(_:)` method returns an array of `LibraryModel` objects that contain the URLs of the fetched images.

### Retrieving Images

#### Retrieving the Next Image

To retrieve the next dog image from the library, call the `getNextImage()` method:

swiftCopy code

`do { let model = try await library.getNextImage() // Do something with the model } catch { // Handle error }`

The `getNextImage()` method returns the next `LibraryModel` object in the library. If the library is empty, a new image is fetched using the `getImage()` method and added to the library.

#### Retrieving the Previous Image

To retrieve the previous dog image from the library, call the `getPreviousImage()` method:

swiftCopy code

`if let model = library.getPreviousImage() { // Do something with the model } else { // Handle empty library }`

The `getPreviousImage()` method returns the previous `LibraryModel` object in the library. If the library is empty or the current index is at the first image, the first image in the library is returned.

License
-------

DogsLibrary is released under the MIT license. See [LICENSE](https://chat.openai.com/LICENSE) for details.
