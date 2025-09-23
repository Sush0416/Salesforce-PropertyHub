public class CollectionExample {
    public void showCollections() {
        // List: stores multiple values in order
        List<String> names = new List<String>{'Alice', 'Bob', 'Charlie'};
        System.debug('List of Names: ' + names);

        // Set: stores unique values only
        Set<Integer> uniqueNumbers = new Set<Integer>{1, 2, 3, 3, 4};
        System.debug('Set of Numbers: ' + uniqueNumbers);

        // Map: stores key-value pairs
        Map<String, Integer> nameToAge = new Map<String, Integer>{
            'Alice' => 25,
            'Bob' => 30,
            'Charlie' => 28
        };
        System.debug('Map of Name to Age: ' + nameToAge);
    }
}