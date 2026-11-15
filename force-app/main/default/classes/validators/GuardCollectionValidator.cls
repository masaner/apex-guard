/**
 * @description Internal validator module for Apex List, Set, and Map preconditions.
 *              Includes explicit overloads for Set<Id>, Set<String>, Set<Integer>, Map<Id, SObject>,
 *              Map<String, Object>, and Map<String, String> to accommodate
 *              Apex generic invariance for Set and Map key types.
 * @group Validators
 */
public inherited sharing class GuardCollectionValidator {
    // =========================================================================
    // isNotEmpty - List
    // =========================================================================

    /**
     * @description Ensures a List is non-null and non-empty.
     * @param collection List&lt;Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated List&lt;Object&gt;.
     */
    public static List<Object> isNotEmpty(List<Object> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a List is non-null and non-empty with a custom message.
     * @param collection List&lt;Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated List&lt;Object&gt;.
     */
    public static List<Object> isNotEmpty(
        List<Object> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a List is non-null and non-empty, throwing a custom exception.
     * @param collection List&lt;Object&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated List&lt;Object&gt;.
     */
    public static List<Object> isNotEmpty(List<Object> collection, Exception customException) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    // =========================================================================
    // isNotEmpty - Set
    // =========================================================================

    /**
     * @description Ensures a Set&lt;Object&gt; is non-null and non-empty.
     * @param collection Set&lt;Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;Object&gt;.
     */
    public static Set<Object> isNotEmpty(Set<Object> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;Object&gt;.
     */
    public static Set<Object> isNotEmpty(
        Set<Object> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Object&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Set&lt;Object&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;Object&gt;.
     */
    public static Set<Object> isNotEmpty(Set<Object> collection, Exception customException) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Id&gt; is non-null and non-empty.
     * @param collection Set&lt;Id&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;Id&gt;.
     */
    public static Set<Id> isNotEmpty(Set<Id> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;Id&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;Id&gt;.
     */
    public static Set<Id> isNotEmpty(
        Set<Id> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Id&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Set&lt;Id&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;Id&gt;.
     */
    public static Set<Id> isNotEmpty(Set<Id> collection, Exception customException) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;String&gt; is non-null and non-empty.
     * @param collection Set&lt;String&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;String&gt;.
     */
    public static Set<String> isNotEmpty(Set<String> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;String&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;String&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;String&gt;.
     */
    public static Set<String> isNotEmpty(
        Set<String> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;String&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Set&lt;String&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;String&gt;.
     */
    public static Set<String> isNotEmpty(Set<String> collection, Exception customException) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Integer&gt; is non-null and non-empty.
     * @param collection Set&lt;Integer&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;Integer&gt;.
     */
    public static Set<Integer> isNotEmpty(Set<Integer> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;Integer&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;Integer&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;Integer&gt;.
     */
    public static Set<Integer> isNotEmpty(
        Set<Integer> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Integer&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Set&lt;Integer&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;Integer&gt;.
     */
    public static Set<Integer> isNotEmpty(Set<Integer> collection, Exception customException) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    // =========================================================================
    // isNotEmpty - Map
    // =========================================================================

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and non-empty.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> isNotEmpty(Map<Object, Object> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> isNotEmpty(
        Map<Object, Object> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> isNotEmpty(
        Map<Object, Object> collection,
        Exception customException
    ) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and non-empty.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> isNotEmpty(Map<Id, SObject> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> isNotEmpty(
        Map<Id, SObject> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> isNotEmpty(
        Map<Id, SObject> collection,
        Exception customException
    ) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and non-empty.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> isNotEmpty(Map<String, Object> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> isNotEmpty(
        Map<String, Object> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> isNotEmpty(
        Map<String, Object> collection,
        Exception customException
    ) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and non-empty.
     * @param collection Map&lt;String, String&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;String, String&gt;.
     */
    public static Map<String, String> isNotEmpty(Map<String, String> collection, String paramName) {
        return isNotEmpty(collection, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;String, String&gt; to validate.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;String, String&gt;.
     */
    public static Map<String, String> isNotEmpty(
        Map<String, String> collection,
        String paramName,
        String customMessage
    ) {
        if (collection == null || collection.isEmpty()) {
            failEmptyCollection(paramName, customMessage, collection);
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and non-empty, throwing a custom exception.
     * @param collection Map&lt;String, String&gt; to validate.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;String, String&gt;.
     */
    public static Map<String, String> isNotEmpty(
        Map<String, String> collection,
        Exception customException
    ) {
        if (collection == null || collection.isEmpty()) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_EMPTY_COLLECTION,
                collection
            );
        }
        return collection;
    }

    // =========================================================================
    // hasSizeEqualTo
    // =========================================================================

    /**
     * @description Ensures a List has the exact expected element count.
     * @param collection List&lt;Object&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated List&lt;Object&gt;.
     */
    public static List<Object> hasSizeEqualTo(
        List<Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a List has the exact expected element count with a custom message.
     * @param collection List&lt;Object&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated List&lt;Object&gt;.
     */
    public static List<Object> hasSizeEqualTo(
        List<Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a List has the exact expected size, throwing a custom exception.
     * @param collection List&lt;Object&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated List&lt;Object&gt;.
     */
    public static List<Object> hasSizeEqualTo(
        List<Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Object&gt; has the exact expected element count.
     * @param collection Set&lt;Object&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;Object&gt;.
     */
    public static Set<Object> hasSizeEqualTo(
        Set<Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; has the exact expected size with a custom message.
     * @param collection Set&lt;Object&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;Object&gt;.
     */
    public static Set<Object> hasSizeEqualTo(
        Set<Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Object&gt; has the exact expected size, throwing a custom exception.
     * @param collection Set&lt;Object&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;Object&gt;.
     */
    public static Set<Object> hasSizeEqualTo(
        Set<Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Id&gt; has the exact expected element count.
     * @param collection Set&lt;Id&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;Id&gt;.
     */
    public static Set<Id> hasSizeEqualTo(
        Set<Id> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; has the exact expected size with a custom message.
     * @param collection Set&lt;Id&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;Id&gt;.
     */
    public static Set<Id> hasSizeEqualTo(
        Set<Id> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a Set&lt;Id&gt; has the exact expected size, throwing a custom exception.
     * @param collection Set&lt;Id&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;Id&gt;.
     */
    public static Set<Id> hasSizeEqualTo(
        Set<Id> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Set&lt;String&gt; has the exact expected element count.
     * @param collection Set&lt;String&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Set&lt;String&gt;.
     */
    public static Set<String> hasSizeEqualTo(
        Set<String> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a Set&lt;String&gt; has the exact expected size with a custom message.
     * @param collection Set&lt;String&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Set&lt;String&gt;.
     */
    public static Set<String> hasSizeEqualTo(
        Set<String> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a Set&lt;String&gt; has the exact expected size, throwing a custom exception.
     * @param collection Set&lt;String&gt; to validate.
     * @param expectedSize Exact required element count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Set&lt;String&gt;.
     */
    public static Set<String> hasSizeEqualTo(
        Set<String> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; has the exact expected entry count.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> hasSizeEqualTo(
        Map<Object, Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; has the exact expected size with a custom message.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> hasSizeEqualTo(
        Map<Object, Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; has the exact expected size, throwing a custom exception.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> hasSizeEqualTo(
        Map<Object, Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; has the exact expected entry count.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> hasSizeEqualTo(
        Map<Id, SObject> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; has the exact expected size with a custom message.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> hasSizeEqualTo(
        Map<Id, SObject> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; has the exact expected size, throwing a custom exception.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> hasSizeEqualTo(
        Map<Id, SObject> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; has the exact expected entry count.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> hasSizeEqualTo(
        Map<String, Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return hasSizeEqualTo(collection, expectedSize, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; has the exact expected size with a custom message.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> hasSizeEqualTo(
        Map<String, Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        validateSizeEqualTo(
            collection == null ? null : collection.size(),
            expectedSize,
            paramName,
            customMessage,
            collection
        );
        return collection;
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; has the exact expected size, throwing a custom exception.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param expectedSize Exact required entry count (&gt;= 0).
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> hasSizeEqualTo(
        Map<String, Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        if (
            expectedSize == null ||
            expectedSize < 0 ||
            collection == null ||
            collection.size() != expectedSize
        ) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_COLLECTION_SIZE,
                collection
            );
        }
        return collection;
    }

    // =========================================================================
    // containsKey
    // =========================================================================

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and contains key.
     * @param inputMap Map&lt;Object, Object&gt; to inspect.
     * @param key Required key.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> containsKey(
        Map<Object, Object> inputMap,
        Object key,
        String paramName
    ) {
        return containsKey(inputMap, key, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; contains key with a custom message.
     * @param inputMap Map&lt;Object, Object&gt; to inspect.
     * @param key Required key.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> containsKey(
        Map<Object, Object> inputMap,
        Object key,
        String paramName,
        String customMessage
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            failMissingKey(key, paramName, customMessage, inputMap);
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; contains key, throwing a custom exception.
     * @param inputMap Map&lt;Object, Object&gt; to inspect.
     * @param key Required key.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;Object, Object&gt;.
     */
    public static Map<Object, Object> containsKey(
        Map<Object, Object> inputMap,
        Object key,
        Exception customException
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_MISSING_KEY,
                inputMap
            );
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and contains key.
     * @param inputMap Map&lt;Id, SObject&gt; to inspect.
     * @param key Required Id key.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> containsKey(
        Map<Id, SObject> inputMap,
        Id key,
        String paramName
    ) {
        return containsKey(inputMap, key, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; contains key with a custom message.
     * @param inputMap Map&lt;Id, SObject&gt; to inspect.
     * @param key Required Id key.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> containsKey(
        Map<Id, SObject> inputMap,
        Id key,
        String paramName,
        String customMessage
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            failMissingKey(key, paramName, customMessage, inputMap);
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; contains key, throwing a custom exception.
     * @param inputMap Map&lt;Id, SObject&gt; to inspect.
     * @param key Required Id key.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;Id, SObject&gt;.
     */
    public static Map<Id, SObject> containsKey(
        Map<Id, SObject> inputMap,
        Id key,
        Exception customException
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_MISSING_KEY,
                inputMap
            );
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and contains key.
     * @param inputMap Map&lt;String, Object&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> containsKey(
        Map<String, Object> inputMap,
        String key,
        String paramName
    ) {
        return containsKey(inputMap, key, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; contains key with a custom message.
     * @param inputMap Map&lt;String, Object&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> containsKey(
        Map<String, Object> inputMap,
        String key,
        String paramName,
        String customMessage
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            failMissingKey(key, paramName, customMessage, inputMap);
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; contains key, throwing a custom exception.
     * @param inputMap Map&lt;String, Object&gt; to inspect.
     * @param key Required String key.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;String, Object&gt;.
     */
    public static Map<String, Object> containsKey(
        Map<String, Object> inputMap,
        String key,
        Exception customException
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_MISSING_KEY,
                inputMap
            );
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and contains key.
     * @param inputMap Map&lt;String, String&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in failure diagnostics.
     * @return The validated Map&lt;String, String&gt;.
     */
    public static Map<String, String> containsKey(
        Map<String, String> inputMap,
        String key,
        String paramName
    ) {
        return containsKey(inputMap, key, paramName, null);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; contains key with a custom message.
     * @param inputMap Map&lt;String, String&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in failure diagnostics.
     * @param customMessage Optional override error message.
     * @return The validated Map&lt;String, String&gt;.
     */
    public static Map<String, String> containsKey(
        Map<String, String> inputMap,
        String key,
        String paramName,
        String customMessage
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            failMissingKey(key, paramName, customMessage, inputMap);
        }
        return inputMap;
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; contains key, throwing a custom exception.
     * @param inputMap Map&lt;String, String&gt; to inspect.
     * @param key Required String key.
     * @param customException Custom Exception instance to throw on failure.
     * @return The validated Map&lt;String, String&gt;.
     */
    public static Map<String, String> containsKey(
        Map<String, String> inputMap,
        String key,
        Exception customException
    ) {
        if (inputMap == null || !inputMap.containsKey(key)) {
            GuardContext.failWithCustomException(
                customException,
                null,
                GuardException.ERR_MISSING_KEY,
                inputMap
            );
        }
        return inputMap;
    }

    // =========================================================================
    // Helpers
    // =========================================================================

    private static void failEmptyCollection(
        String paramName,
        String customMessage,
        Object actualValue
    ) {
        String message = String.isNotBlank(customMessage)
            ? customMessage
            : 'Parameter \'' +
              GuardObjectValidator.safeParamName(paramName) +
              '\' must not be null or empty.';
        GuardContext.fail(message, paramName, GuardException.ERR_EMPTY_COLLECTION, actualValue);
    }

    private static void validateSizeEqualTo(
        Integer actualSize,
        Integer expectedSize,
        String paramName,
        String customMessage,
        Object actualValue
    ) {
        if (expectedSize == null || expectedSize < 0) {
            GuardContext.fail(
                'Expected size for parameter \'' +
                    GuardObjectValidator.safeParamName(paramName) +
                    '\' must be zero or greater.',
                'expectedSize',
                GuardException.ERR_INVALID_GUARD_ARGUMENT,
                expectedSize
            );
        }
        if (actualSize == null || actualSize != expectedSize) {
            String actualDesc = actualSize == null ? 'null' : String.valueOf(actualSize);
            String message = String.isNotBlank(customMessage)
                ? customMessage
                : 'Parameter \'' +
                  GuardObjectValidator.safeParamName(paramName) +
                  '\' must contain exactly ' +
                  expectedSize +
                  ' item(s), but had ' +
                  actualDesc +
                  '.';
            GuardContext.fail(message, paramName, GuardException.ERR_COLLECTION_SIZE, actualValue);
        }
    }

    private static void failMissingKey(
        Object key,
        String paramName,
        String customMessage,
        Object actualValue
    ) {
        String message = String.isNotBlank(customMessage)
            ? customMessage
            : 'Parameter \'' +
              GuardObjectValidator.safeParamName(paramName) +
              '\' must contain key \'' +
              String.valueOf(key) +
              '\'.';
        GuardContext.fail(message, paramName, GuardException.ERR_MISSING_KEY, actualValue);
    }
}
