/**
 * @description Public entry-point facade for ApexGuard: a zero-dependency, fail-fast defensive
 *              programming library inspired by .NET CommunityToolkit.Diagnostics.Guard.
 *              Provides positive-assertion preconditions with pass-through return values across
 *              Apex Services, Triggers, LWC (@AuraEnabled), Flows/Agentforce, REST APIs, and
 *              Asynchronous Apex.
 * @group Core
 */
public inherited sharing class Guard {
    // =========================================================================
    // 1. General / Nullability
    // =========================================================================

    /**
     * @description Ensures the specified object reference is not null.
     * @param value Object reference to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-null Object value for single-line pass-through assignment.
     * @throws GuardException when value is null (or AuraHandledException in LWC/Aura context).
     */
    public static Object isNotNull(Object value, String paramName) {
        return GuardObjectValidator.isNotNull(value, paramName);
    }

    /**
     * @description Ensures the specified object reference is not null with a custom message.
     * @param value Object reference to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-null Object value.
     * @throws GuardException when value is null (or AuraHandledException in LWC/Aura context).
     */
    public static Object isNotNull(Object value, String paramName, String customMessage) {
        return GuardObjectValidator.isNotNull(value, paramName, customMessage);
    }

    /**
     * @description Ensures the specified object reference is not null, throwing a custom Exception on failure.
     * @param value Object reference to validate.
     * @param customException Caller-provided Exception instance thrown if value is null.
     * @return The validated non-null Object value.
     * @throws Exception customException when value is null.
     */
    public static Object isNotNull(Object value, Exception customException) {
        return GuardObjectValidator.isNotNull(value, customException);
    }

    /**
     * @description Ensures the specified object reference is null.
     * @param value Object reference to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return Always returns null when validation succeeds.
     * @throws GuardException when value is non-null (or AuraHandledException in LWC/Aura context).
     */
    public static Object isNull(Object value, String paramName) {
        return GuardObjectValidator.isNull(value, paramName);
    }

    /**
     * @description Ensures the specified object reference is null with a custom message.
     * @param value Object reference to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return Always returns null when validation succeeds.
     * @throws GuardException when value is non-null (or AuraHandledException in LWC/Aura context).
     */
    public static Object isNull(Object value, String paramName, String customMessage) {
        return GuardObjectValidator.isNull(value, paramName, customMessage);
    }

    /**
     * @description Ensures the specified object reference is null, throwing a custom Exception on failure.
     * @param value Object reference to validate.
     * @param customException Caller-provided Exception instance thrown if value is non-null.
     * @return Always returns null when validation succeeds.
     * @throws Exception customException when value is non-null.
     */
    public static Object isNull(Object value, Exception customException) {
        return GuardObjectValidator.isNull(value, customException);
    }

    // =========================================================================
    // 2. Boolean / State Assertions
    // =========================================================================

    /**
     * @description Ensures a boolean precondition evaluates to true.
     * @param condition Boolean condition to assert (null fails validation).
     * @param message Diagnostic message surfaced when condition is not true.
     * @return Boolean true when validation succeeds.
     * @throws GuardException when condition is false or null (or AuraHandledException in LWC/Aura context).
     */
    public static Boolean isTrue(Boolean condition, String message) {
        return GuardObjectValidator.isTrue(condition, message);
    }

    /**
     * @description Ensures a boolean precondition evaluates to true, throwing a custom Exception on failure.
     * @param condition Boolean condition to assert (null fails validation).
     * @param customException Caller-provided Exception instance thrown if condition is not true.
     * @return Boolean true when validation succeeds.
     * @throws Exception customException when condition is false or null.
     */
    public static Boolean isTrue(Boolean condition, Exception customException) {
        return GuardObjectValidator.isTrue(condition, customException);
    }

    /**
     * @description Ensures a boolean precondition evaluates to false.
     * @param condition Boolean condition to assert (null fails validation).
     * @param message Diagnostic message surfaced when condition is not false.
     * @return Boolean false when validation succeeds.
     * @throws GuardException when condition is true or null (or AuraHandledException in LWC/Aura context).
     */
    public static Boolean isFalse(Boolean condition, String message) {
        return GuardObjectValidator.isFalse(condition, message);
    }

    /**
     * @description Ensures a boolean precondition evaluates to false, throwing a custom Exception on failure.
     * @param condition Boolean condition to assert (null fails validation).
     * @param customException Caller-provided Exception instance thrown if condition is not false.
     * @return Boolean false when validation succeeds.
     * @throws Exception customException when condition is true or null.
     */
    public static Boolean isFalse(Boolean condition, Exception customException) {
        return GuardObjectValidator.isFalse(condition, customException);
    }

    // =========================================================================
    // 3. Strings
    // =========================================================================

    /**
     * @description Ensures a String is neither null nor zero-length.
     * @param value String value to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-empty String.
     * @throws GuardException when value is null or empty (or AuraHandledException in LWC/Aura context).
     */
    public static String isNotEmpty(String value, String paramName) {
        return GuardStringValidator.isNotEmpty(value, paramName);
    }

    /**
     * @description Ensures a String is neither null nor zero-length with a custom message.
     * @param value String value to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-empty String.
     * @throws GuardException when value is null or empty (or AuraHandledException in LWC/Aura context).
     */
    public static String isNotEmpty(String value, String paramName, String customMessage) {
        return GuardStringValidator.isNotEmpty(value, paramName, customMessage);
    }

    /**
     * @description Ensures a String is neither null nor zero-length, throwing a custom Exception on failure.
     * @param value String value to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated non-empty String.
     * @throws Exception customException when value is null or empty.
     */
    public static String isNotEmpty(String value, Exception customException) {
        return GuardStringValidator.isNotEmpty(value, customException);
    }

    /**
     * @description Ensures a String is not null, empty, or whitespace-only.
     * @param value String value to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-blank String.
     * @throws GuardException when value is null, empty, or whitespace-only.
     */
    public static String isNotBlank(String value, String paramName) {
        return GuardStringValidator.isNotBlank(value, paramName);
    }

    /**
     * @description Ensures a String is not null, empty, or whitespace-only with a custom message.
     * @param value String value to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-blank String.
     * @throws GuardException when value is null, empty, or whitespace-only.
     */
    public static String isNotBlank(String value, String paramName, String customMessage) {
        return GuardStringValidator.isNotBlank(value, paramName, customMessage);
    }

    /**
     * @description Ensures a String is not null, empty, or whitespace-only, throwing a custom Exception on failure.
     * @param value String value to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated non-blank String.
     * @throws Exception customException when value is null, empty, or whitespace-only.
     */
    public static String isNotBlank(String value, Exception customException) {
        return GuardStringValidator.isNotBlank(value, customException);
    }

    /**
     * @description Ensures a non-null String has an exact character length.
     * @param value String value to validate (null fails validation).
     * @param expectedLength Exact required character length (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated String.
     * @throws GuardException when value is null or its length differs from expectedLength.
     */
    public static String hasLengthEqualTo(String value, Integer expectedLength, String paramName) {
        return GuardStringValidator.hasLengthEqualTo(value, expectedLength, paramName);
    }

    /**
     * @description Ensures a non-null String has an exact character length with a custom message.
     * @param value String value to validate (null fails validation).
     * @param expectedLength Exact required character length (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated String.
     * @throws GuardException when value is null or its length differs from expectedLength.
     */
    public static String hasLengthEqualTo(
        String value,
        Integer expectedLength,
        String paramName,
        String customMessage
    ) {
        return GuardStringValidator.hasLengthEqualTo(
            value,
            expectedLength,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a non-null String has an exact length, throwing a custom Exception on failure.
     * @param value String value to validate.
     * @param expectedLength Exact required character length (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated String.
     * @throws Exception customException on length mismatch or null input.
     */
    public static String hasLengthEqualTo(
        String value,
        Integer expectedLength,
        Exception customException
    ) {
        return GuardStringValidator.hasLengthEqualTo(value, expectedLength, customException);
    }

    /**
     * @description Ensures a non-null String does not exceed a maximum character length.
     * @param value String value to validate (null fails validation).
     * @param maxLength Maximum allowed character length (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated String.
     * @throws GuardException when value is null or exceeds maxLength.
     */
    public static String hasMaxLength(String value, Integer maxLength, String paramName) {
        return GuardStringValidator.hasMaxLength(value, maxLength, paramName);
    }

    /**
     * @description Ensures a non-null String does not exceed a maximum length with a custom message.
     * @param value String value to validate (null fails validation).
     * @param maxLength Maximum allowed character length (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated String.
     * @throws GuardException when value is null or exceeds maxLength.
     */
    public static String hasMaxLength(
        String value,
        Integer maxLength,
        String paramName,
        String customMessage
    ) {
        return GuardStringValidator.hasMaxLength(value, maxLength, paramName, customMessage);
    }

    /**
     * @description Ensures a non-null String does not exceed a maximum length, throwing a custom Exception on failure.
     * @param value String value to validate.
     * @param maxLength Maximum allowed character length (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated String.
     * @throws Exception customException when value is null or exceeds maxLength.
     */
    public static String hasMaxLength(String value, Integer maxLength, Exception customException) {
        return GuardStringValidator.hasMaxLength(value, maxLength, customException);
    }

    /**
     * @description Ensures a non-null String matches the full regular expression pattern.
     * @param value String value to validate (null fails validation).
     * @param regexPattern Apex regular expression pattern.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated String.
     * @throws GuardException when value is null or does not match regexPattern.
     */
    public static String matchesRegex(String value, String regexPattern, String paramName) {
        return GuardStringValidator.matchesRegex(value, regexPattern, paramName);
    }

    /**
     * @description Ensures a non-null String matches the full regular expression pattern with a custom message.
     * @param value String value to validate (null fails validation).
     * @param regexPattern Apex regular expression pattern.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated String.
     * @throws GuardException when value is null or does not match regexPattern.
     */
    public static String matchesRegex(
        String value,
        String regexPattern,
        String paramName,
        String customMessage
    ) {
        return GuardStringValidator.matchesRegex(value, regexPattern, paramName, customMessage);
    }

    /**
     * @description Ensures a non-null String matches the regex pattern, throwing a custom Exception on failure.
     * @param value String value to validate.
     * @param regexPattern Apex regular expression pattern.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated String.
     * @throws Exception customException when value is null or does not match regexPattern.
     */
    public static String matchesRegex(
        String value,
        String regexPattern,
        Exception customException
    ) {
        return GuardStringValidator.matchesRegex(value, regexPattern, customException);
    }

    // =========================================================================
    // 4. Numeric (Decimal, Integer, Long; Double widens cleanly to Decimal)
    // =========================================================================

    /**
     * @description Ensures a Decimal value is strictly greater than minExclusive.
     * @param value Decimal value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or <= minExclusive.
     */
    public static Decimal isGreaterThan(Decimal value, Decimal minExclusive, String paramName) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName);
    }

    /**
     * @description Ensures a Decimal value is strictly greater than minExclusive with a custom message.
     * @param value Decimal value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or <= minExclusive.
     */
    public static Decimal isGreaterThan(
        Decimal value,
        Decimal minExclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName, customMessage);
    }

    /**
     * @description Ensures a Decimal value is strictly greater than minExclusive, throwing a custom Exception.
     * @param value Decimal value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Decimal value.
     * @throws Exception customException when value is null or <= minExclusive.
     */
    public static Decimal isGreaterThan(
        Decimal value,
        Decimal minExclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, customException);
    }

    /**
     * @description Ensures an Integer value is strictly greater than minExclusive.
     * @param value Integer value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Integer value.
     * @throws GuardException when value is null or <= minExclusive.
     */
    public static Integer isGreaterThan(Integer value, Integer minExclusive, String paramName) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName);
    }

    /**
     * @description Ensures an Integer value is strictly greater than minExclusive with a custom message.
     * @param value Integer value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Integer value.
     * @throws GuardException when value is null or <= minExclusive.
     */
    public static Integer isGreaterThan(
        Integer value,
        Integer minExclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName, customMessage);
    }

    /**
     * @description Ensures an Integer value is strictly greater than minExclusive, throwing a custom Exception.
     * @param value Integer value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Integer value.
     * @throws Exception customException when value is null or <= minExclusive.
     */
    public static Integer isGreaterThan(
        Integer value,
        Integer minExclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, customException);
    }

    /**
     * @description Ensures a Long value is strictly greater than minExclusive.
     * @param value Long value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Long value.
     * @throws GuardException when value is null or <= minExclusive.
     */
    public static Long isGreaterThan(Long value, Long minExclusive, String paramName) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName);
    }

    /**
     * @description Ensures a Long value is strictly greater than minExclusive with a custom message.
     * @param value Long value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Long value.
     * @throws GuardException when value is null or <= minExclusive.
     */
    public static Long isGreaterThan(
        Long value,
        Long minExclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, paramName, customMessage);
    }

    /**
     * @description Ensures a Long value is strictly greater than minExclusive, throwing a custom Exception.
     * @param value Long value to validate.
     * @param minExclusive Exclusive lower bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Long value.
     * @throws Exception customException when value is null or <= minExclusive.
     */
    public static Long isGreaterThan(Long value, Long minExclusive, Exception customException) {
        return GuardNumericValidator.isGreaterThan(value, minExclusive, customException);
    }

    /**
     * @description Ensures a Decimal value is greater than or equal to minInclusive.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or < minInclusive.
     */
    public static Decimal isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, paramName);
    }

    /**
     * @description Ensures a Decimal value is greater than or equal to minInclusive with a custom message.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or < minInclusive.
     */
    public static Decimal isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(
            value,
            minInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Decimal value is >= minInclusive, throwing a custom Exception on failure.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Decimal value.
     * @throws Exception customException when value is null or < minInclusive.
     */
    public static Decimal isGreaterThanOrEqualTo(
        Decimal value,
        Decimal minInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, customException);
    }

    /**
     * @description Ensures an Integer value is greater than or equal to minInclusive.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Integer value.
     * @throws GuardException when value is null or < minInclusive.
     */
    public static Integer isGreaterThanOrEqualTo(
        Integer value,
        Integer minInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, paramName);
    }

    /**
     * @description Ensures an Integer value is >= minInclusive with a custom message.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Integer value.
     * @throws GuardException when value is null or < minInclusive.
     */
    public static Integer isGreaterThanOrEqualTo(
        Integer value,
        Integer minInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(
            value,
            minInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures an Integer value is >= minInclusive, throwing a custom Exception on failure.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Integer value.
     * @throws Exception customException when value is null or < minInclusive.
     */
    public static Integer isGreaterThanOrEqualTo(
        Integer value,
        Integer minInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, customException);
    }

    /**
     * @description Ensures a Long value is greater than or equal to minInclusive.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Long value.
     * @throws GuardException when value is null or < minInclusive.
     */
    public static Long isGreaterThanOrEqualTo(Long value, Long minInclusive, String paramName) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, paramName);
    }

    /**
     * @description Ensures a Long value is >= minInclusive with a custom message.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Long value.
     * @throws GuardException when value is null or < minInclusive.
     */
    public static Long isGreaterThanOrEqualTo(
        Long value,
        Long minInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(
            value,
            minInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Long value is >= minInclusive, throwing a custom Exception on failure.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Long value.
     * @throws Exception customException when value is null or < minInclusive.
     */
    public static Long isGreaterThanOrEqualTo(
        Long value,
        Long minInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isGreaterThanOrEqualTo(value, minInclusive, customException);
    }

    /**
     * @description Ensures a Decimal value is strictly less than maxExclusive.
     * @param value Decimal value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or >= maxExclusive.
     */
    public static Decimal isLessThan(Decimal value, Decimal maxExclusive, String paramName) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, paramName);
    }

    /**
     * @description Ensures a Decimal value is strictly less than maxExclusive with a custom message.
     * @param value Decimal value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or >= maxExclusive.
     */
    public static Decimal isLessThan(
        Decimal value,
        Decimal maxExclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, paramName, customMessage);
    }

    /**
     * @description Ensures a Decimal value is strictly less than maxExclusive, throwing a custom Exception.
     * @param value Decimal value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Decimal value.
     * @throws Exception customException when value is null or >= maxExclusive.
     */
    public static Decimal isLessThan(
        Decimal value,
        Decimal maxExclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, customException);
    }

    /**
     * @description Ensures an Integer value is strictly less than maxExclusive.
     * @param value Integer value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Integer value.
     * @throws GuardException when value is null or >= maxExclusive.
     */
    public static Integer isLessThan(Integer value, Integer maxExclusive, String paramName) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, paramName);
    }

    /**
     * @description Ensures an Integer value is strictly less than maxExclusive with a custom message.
     * @param value Integer value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Integer value.
     * @throws GuardException when value is null or >= maxExclusive.
     */
    public static Integer isLessThan(
        Integer value,
        Integer maxExclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, paramName, customMessage);
    }

    /**
     * @description Ensures an Integer value is strictly less than maxExclusive, throwing a custom Exception.
     * @param value Integer value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Integer value.
     * @throws Exception customException when value is null or >= maxExclusive.
     */
    public static Integer isLessThan(
        Integer value,
        Integer maxExclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, customException);
    }

    /**
     * @description Ensures a Long value is strictly less than maxExclusive.
     * @param value Long value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Long value.
     * @throws GuardException when value is null or >= maxExclusive.
     */
    public static Long isLessThan(Long value, Long maxExclusive, String paramName) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, paramName);
    }

    /**
     * @description Ensures a Long value is strictly less than maxExclusive with a custom message.
     * @param value Long value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Long value.
     * @throws GuardException when value is null or >= maxExclusive.
     */
    public static Long isLessThan(
        Long value,
        Long maxExclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, paramName, customMessage);
    }

    /**
     * @description Ensures a Long value is strictly less than maxExclusive, throwing a custom Exception.
     * @param value Long value to validate.
     * @param maxExclusive Exclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Long value.
     * @throws Exception customException when value is null or >= maxExclusive.
     */
    public static Long isLessThan(Long value, Long maxExclusive, Exception customException) {
        return GuardNumericValidator.isLessThan(value, maxExclusive, customException);
    }

    /**
     * @description Ensures a Decimal value is less than or equal to maxInclusive.
     * @param value Decimal value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or > maxInclusive.
     */
    public static Decimal isLessThanOrEqualTo(
        Decimal value,
        Decimal maxInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, paramName);
    }

    /**
     * @description Ensures a Decimal value is <= maxInclusive with a custom message.
     * @param value Decimal value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or > maxInclusive.
     */
    public static Decimal isLessThanOrEqualTo(
        Decimal value,
        Decimal maxInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(
            value,
            maxInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Decimal value is <= maxInclusive, throwing a custom Exception on failure.
     * @param value Decimal value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Decimal value.
     * @throws Exception customException when value is null or > maxInclusive.
     */
    public static Decimal isLessThanOrEqualTo(
        Decimal value,
        Decimal maxInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, customException);
    }

    /**
     * @description Ensures an Integer value is less than or equal to maxInclusive.
     * @param value Integer value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Integer value.
     * @throws GuardException when value is null or > maxInclusive.
     */
    public static Integer isLessThanOrEqualTo(
        Integer value,
        Integer maxInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, paramName);
    }

    /**
     * @description Ensures an Integer value is <= maxInclusive with a custom message.
     * @param value Integer value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Integer value.
     * @throws GuardException when value is null or > maxInclusive.
     */
    public static Integer isLessThanOrEqualTo(
        Integer value,
        Integer maxInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(
            value,
            maxInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures an Integer value is <= maxInclusive, throwing a custom Exception on failure.
     * @param value Integer value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Integer value.
     * @throws Exception customException when value is null or > maxInclusive.
     */
    public static Integer isLessThanOrEqualTo(
        Integer value,
        Integer maxInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, customException);
    }

    /**
     * @description Ensures a Long value is less than or equal to maxInclusive.
     * @param value Long value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Long value.
     * @throws GuardException when value is null or > maxInclusive.
     */
    public static Long isLessThanOrEqualTo(Long value, Long maxInclusive, String paramName) {
        return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, paramName);
    }

    /**
     * @description Ensures a Long value is <= maxInclusive with a custom message.
     * @param value Long value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Long value.
     * @throws GuardException when value is null or > maxInclusive.
     */
    public static Long isLessThanOrEqualTo(
        Long value,
        Long maxInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(
            value,
            maxInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Long value is <= maxInclusive, throwing a custom Exception on failure.
     * @param value Long value to validate.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Long value.
     * @throws Exception customException when value is null or > maxInclusive.
     */
    public static Long isLessThanOrEqualTo(
        Long value,
        Long maxInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isLessThanOrEqualTo(value, maxInclusive, customException);
    }

    /**
     * @description Ensures a Decimal value falls within [minInclusive, maxInclusive].
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or outside the inclusive range.
     */
    public static Decimal isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isInRange(value, minInclusive, maxInclusive, paramName);
    }

    /**
     * @description Ensures a Decimal value falls within [minInclusive, maxInclusive] with a custom message.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Decimal value.
     * @throws GuardException when value is null or outside the inclusive range.
     */
    public static Decimal isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isInRange(
            value,
            minInclusive,
            maxInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Decimal value falls within [minInclusive, maxInclusive], throwing a custom Exception.
     * @param value Decimal value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Decimal value.
     * @throws Exception customException when value is null or outside the inclusive range.
     */
    public static Decimal isInRange(
        Decimal value,
        Decimal minInclusive,
        Decimal maxInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isInRange(value, minInclusive, maxInclusive, customException);
    }

    /**
     * @description Ensures an Integer value falls within [minInclusive, maxInclusive].
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Integer value.
     * @throws GuardException when value is null or outside the inclusive range.
     */
    public static Integer isInRange(
        Integer value,
        Integer minInclusive,
        Integer maxInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isInRange(value, minInclusive, maxInclusive, paramName);
    }

    /**
     * @description Ensures an Integer value falls within [minInclusive, maxInclusive] with a custom message.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Integer value.
     * @throws GuardException when value is null or outside the inclusive range.
     */
    public static Integer isInRange(
        Integer value,
        Integer minInclusive,
        Integer maxInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isInRange(
            value,
            minInclusive,
            maxInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures an Integer value falls within [minInclusive, maxInclusive], throwing a custom Exception.
     * @param value Integer value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Integer value.
     * @throws Exception customException when value is null or outside the inclusive range.
     */
    public static Integer isInRange(
        Integer value,
        Integer minInclusive,
        Integer maxInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isInRange(value, minInclusive, maxInclusive, customException);
    }

    /**
     * @description Ensures a Long value falls within [minInclusive, maxInclusive].
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Long value.
     * @throws GuardException when value is null or outside the inclusive range.
     */
    public static Long isInRange(
        Long value,
        Long minInclusive,
        Long maxInclusive,
        String paramName
    ) {
        return GuardNumericValidator.isInRange(value, minInclusive, maxInclusive, paramName);
    }

    /**
     * @description Ensures a Long value falls within [minInclusive, maxInclusive] with a custom message.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Long value.
     * @throws GuardException when value is null or outside the inclusive range.
     */
    public static Long isInRange(
        Long value,
        Long minInclusive,
        Long maxInclusive,
        String paramName,
        String customMessage
    ) {
        return GuardNumericValidator.isInRange(
            value,
            minInclusive,
            maxInclusive,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Long value falls within [minInclusive, maxInclusive], throwing a custom Exception.
     * @param value Long value to validate.
     * @param minInclusive Inclusive lower bound.
     * @param maxInclusive Inclusive upper bound.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Long value.
     * @throws Exception customException when value is null or outside the inclusive range.
     */
    public static Long isInRange(
        Long value,
        Long minInclusive,
        Long maxInclusive,
        Exception customException
    ) {
        return GuardNumericValidator.isInRange(value, minInclusive, maxInclusive, customException);
    }

    /**
     * @description Ensures a Decimal value is non-null and not equal to zero.
     * @param value Decimal value to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-zero Decimal value.
     * @throws GuardException when value is null or 0.
     */
    public static Decimal isNotZero(Decimal value, String paramName) {
        return GuardNumericValidator.isNotZero(value, paramName);
    }

    /**
     * @description Ensures a Decimal value is non-null and not equal to zero with a custom message.
     * @param value Decimal value to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-zero Decimal value.
     * @throws GuardException when value is null or 0.
     */
    public static Decimal isNotZero(Decimal value, String paramName, String customMessage) {
        return GuardNumericValidator.isNotZero(value, paramName, customMessage);
    }

    /**
     * @description Ensures a Decimal value is non-null and not equal to zero, throwing a custom Exception.
     * @param value Decimal value to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated non-zero Decimal value.
     * @throws Exception customException when value is null or 0.
     */
    public static Decimal isNotZero(Decimal value, Exception customException) {
        return GuardNumericValidator.isNotZero(value, customException);
    }

    /**
     * @description Ensures an Integer value is non-null and not equal to zero.
     * @param value Integer value to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-zero Integer value.
     * @throws GuardException when value is null or 0.
     */
    public static Integer isNotZero(Integer value, String paramName) {
        return GuardNumericValidator.isNotZero(value, paramName);
    }

    /**
     * @description Ensures an Integer value is non-null and not equal to zero with a custom message.
     * @param value Integer value to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-zero Integer value.
     * @throws GuardException when value is null or 0.
     */
    public static Integer isNotZero(Integer value, String paramName, String customMessage) {
        return GuardNumericValidator.isNotZero(value, paramName, customMessage);
    }

    /**
     * @description Ensures an Integer value is non-null and not equal to zero, throwing a custom Exception.
     * @param value Integer value to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated non-zero Integer value.
     * @throws Exception customException when value is null or 0.
     */
    public static Integer isNotZero(Integer value, Exception customException) {
        return GuardNumericValidator.isNotZero(value, customException);
    }

    /**
     * @description Ensures a Long value is non-null and not equal to zero.
     * @param value Long value to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-zero Long value.
     * @throws GuardException when value is null or 0.
     */
    public static Long isNotZero(Long value, String paramName) {
        return GuardNumericValidator.isNotZero(value, paramName);
    }

    /**
     * @description Ensures a Long value is non-null and not equal to zero with a custom message.
     * @param value Long value to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-zero Long value.
     * @throws GuardException when value is null or 0.
     */
    public static Long isNotZero(Long value, String paramName, String customMessage) {
        return GuardNumericValidator.isNotZero(value, paramName, customMessage);
    }

    /**
     * @description Ensures a Long value is non-null and not equal to zero, throwing a custom Exception.
     * @param value Long value to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated non-zero Long value.
     * @throws Exception customException when value is null or 0.
     */
    public static Long isNotZero(Long value, Exception customException) {
        return GuardNumericValidator.isNotZero(value, customException);
    }

    // =========================================================================
    // 5. Collections (List, Set, Map with Apex Covariance Overloads)
    // =========================================================================

    /**
     * @description Ensures a List is non-null and contains at least one element.
     * @param collection List to validate (accepts any typed List via Apex List covariance).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated non-empty List&lt;Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static List<Object> isNotEmpty(List<Object> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a List is non-null and non-empty with a custom message.
     * @param collection List to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated non-empty List&lt;Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static List<Object> isNotEmpty(
        List<Object> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a List is non-null and non-empty, throwing a custom Exception on failure.
     * @param collection List to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated non-empty List&lt;Object&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static List<Object> isNotEmpty(List<Object> collection, Exception customException) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; is non-null and non-empty.
     * @param collection Set&lt;Object&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<Object> isNotEmpty(Set<Object> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;Object&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<Object> isNotEmpty(
        Set<Object> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Set&lt;Object&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;Object&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Set<Object> isNotEmpty(Set<Object> collection, Exception customException) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; is non-null and non-empty (explicit overload for Apex Set invariance).
     * @param collection Set&lt;Id&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;Id&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<Id> isNotEmpty(Set<Id> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;Id&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;Id&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<Id> isNotEmpty(Set<Id> collection, String paramName, String customMessage) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Set&lt;Id&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;Id&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Set<Id> isNotEmpty(Set<Id> collection, Exception customException) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Set&lt;String&gt; is non-null and non-empty (explicit overload for Apex Set invariance).
     * @param collection Set&lt;String&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;String&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<String> isNotEmpty(Set<String> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Set&lt;String&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;String&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;String&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<String> isNotEmpty(
        Set<String> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Set&lt;String&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Set&lt;String&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;String&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Set<String> isNotEmpty(Set<String> collection, Exception customException) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Set&lt;Integer&gt; is non-null and non-empty (explicit overload for Apex Set invariance).
     * @param collection Set&lt;Integer&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;Integer&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<Integer> isNotEmpty(Set<Integer> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Set&lt;Integer&gt; is non-null and non-empty with a custom message.
     * @param collection Set&lt;Integer&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;Integer&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Set<Integer> isNotEmpty(
        Set<Integer> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Set&lt;Integer&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Set&lt;Integer&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;Integer&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Set<Integer> isNotEmpty(Set<Integer> collection, Exception customException) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and non-empty.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<Object, Object> isNotEmpty(Map<Object, Object> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<Object, Object> isNotEmpty(
        Map<Object, Object> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Map<Object, Object> isNotEmpty(
        Map<Object, Object> collection,
        Exception customException
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; (such as Trigger.newMap or Trigger.oldMap) is non-null and non-empty.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<Id, SObject> isNotEmpty(Map<Id, SObject> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<Id, SObject> isNotEmpty(
        Map<Id, SObject> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Map<Id, SObject> isNotEmpty(
        Map<Id, SObject> collection,
        Exception customException
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and non-empty.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<String, Object> isNotEmpty(Map<String, Object> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<String, Object> isNotEmpty(
        Map<String, Object> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Map<String, Object> isNotEmpty(
        Map<String, Object> collection,
        Exception customException
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and non-empty.
     * @param collection Map&lt;String, String&gt; to validate.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;String, String&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<String, String> isNotEmpty(Map<String, String> collection, String paramName) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and non-empty with a custom message.
     * @param collection Map&lt;String, String&gt; to validate.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;String, String&gt;.
     * @throws GuardException when collection is null or empty.
     */
    public static Map<String, String> isNotEmpty(
        Map<String, String> collection,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and non-empty, throwing a custom Exception.
     * @param collection Map&lt;String, String&gt; to validate.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;String, String&gt;.
     * @throws Exception customException when collection is null or empty.
     */
    public static Map<String, String> isNotEmpty(
        Map<String, String> collection,
        Exception customException
    ) {
        return GuardCollectionValidator.isNotEmpty(collection, customException);
    }

    /**
     * @description Ensures a List has the exact expected element count.
     * @param collection List to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated List&lt;Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static List<Object> hasSizeEqualTo(
        List<Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a List has the exact expected element count with a custom message.
     * @param collection List to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated List&lt;Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static List<Object> hasSizeEqualTo(
        List<Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a List has the exact expected size, throwing a custom Exception on failure.
     * @param collection List to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated List&lt;Object&gt;.
     * @throws Exception customException when collection is null or its size differs from expectedSize.
     */
    public static List<Object> hasSizeEqualTo(
        List<Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; has the exact expected element count.
     * @param collection Set&lt;Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Set<Object> hasSizeEqualTo(
        Set<Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a Set&lt;Object&gt; has the exact expected size with a custom message.
     * @param collection Set&lt;Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Set<Object> hasSizeEqualTo(
        Set<Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Set&lt;Object&gt; has the exact expected size, throwing a custom Exception.
     * @param collection Set&lt;Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;Object&gt;.
     * @throws Exception customException when collection is null or size differs.
     */
    public static Set<Object> hasSizeEqualTo(
        Set<Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; has the exact expected element count.
     * @param collection Set&lt;Id&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;Id&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Set<Id> hasSizeEqualTo(
        Set<Id> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a Set&lt;Id&gt; has the exact expected size with a custom message.
     * @param collection Set&lt;Id&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;Id&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Set<Id> hasSizeEqualTo(
        Set<Id> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Set&lt;Id&gt; has the exact expected size, throwing a custom Exception.
     * @param collection Set&lt;Id&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;Id&gt;.
     * @throws Exception customException when collection is null or size differs.
     */
    public static Set<Id> hasSizeEqualTo(
        Set<Id> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Set&lt;String&gt; has the exact expected element count.
     * @param collection Set&lt;String&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Set&lt;String&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Set<String> hasSizeEqualTo(
        Set<String> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a Set&lt;String&gt; has the exact expected size with a custom message.
     * @param collection Set&lt;String&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Set&lt;String&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Set<String> hasSizeEqualTo(
        Set<String> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Set&lt;String&gt; has the exact expected size, throwing a custom Exception.
     * @param collection Set&lt;String&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Set&lt;String&gt;.
     * @throws Exception customException when collection is null or size differs.
     */
    public static Set<String> hasSizeEqualTo(
        Set<String> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; has the exact expected entry count.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Map<Object, Object> hasSizeEqualTo(
        Map<Object, Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; has the exact expected size with a custom message.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Map<Object, Object> hasSizeEqualTo(
        Map<Object, Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; has the exact expected size, throwing a custom Exception.
     * @param collection Map&lt;Object, Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws Exception customException when collection is null or size differs.
     */
    public static Map<Object, Object> hasSizeEqualTo(
        Map<Object, Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; has the exact expected entry count.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Map<Id, SObject> hasSizeEqualTo(
        Map<Id, SObject> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; has the exact expected size with a custom message.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Map<Id, SObject> hasSizeEqualTo(
        Map<Id, SObject> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; has the exact expected size, throwing a custom Exception.
     * @param collection Map&lt;Id, SObject&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws Exception customException when collection is null or size differs.
     */
    public static Map<Id, SObject> hasSizeEqualTo(
        Map<Id, SObject> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; has the exact expected entry count.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Map<String, Object> hasSizeEqualTo(
        Map<String, Object> collection,
        Integer expectedSize,
        String paramName
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, paramName);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; has the exact expected size with a custom message.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws GuardException when collection is null or its size differs from expectedSize.
     */
    public static Map<String, Object> hasSizeEqualTo(
        Map<String, Object> collection,
        Integer expectedSize,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(
            collection,
            expectedSize,
            paramName,
            customMessage
        );
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; has the exact expected size, throwing a custom Exception.
     * @param collection Map&lt;String, Object&gt; to validate.
     * @param expectedSize Exact required size (>= 0).
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws Exception customException when collection is null or size differs.
     */
    public static Map<String, Object> hasSizeEqualTo(
        Map<String, Object> collection,
        Integer expectedSize,
        Exception customException
    ) {
        return GuardCollectionValidator.hasSizeEqualTo(collection, expectedSize, customException);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; is non-null and contains the specified key.
     * @param inputMap Map to inspect.
     * @param key Required key.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<Object, Object> containsKey(
        Map<Object, Object> inputMap,
        Object key,
        String paramName
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; contains the specified key with a custom message.
     * @param inputMap Map to inspect.
     * @param key Required key.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<Object, Object> containsKey(
        Map<Object, Object> inputMap,
        Object key,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;Object, Object&gt; contains the key, throwing a custom Exception.
     * @param inputMap Map to inspect.
     * @param key Required key.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;Object, Object&gt;.
     * @throws Exception customException when inputMap is null or does not contain key.
     */
    public static Map<Object, Object> containsKey(
        Map<Object, Object> inputMap,
        Object key,
        Exception customException
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, customException);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; is non-null and contains the specified Id key.
     * @param inputMap Map&lt;Id, SObject&gt; to inspect.
     * @param key Required Id key.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<Id, SObject> containsKey(
        Map<Id, SObject> inputMap,
        Id key,
        String paramName
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; contains the specified Id key with a custom message.
     * @param inputMap Map&lt;Id, SObject&gt; to inspect.
     * @param key Required Id key.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<Id, SObject> containsKey(
        Map<Id, SObject> inputMap,
        Id key,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;Id, SObject&gt; contains the specified Id key, throwing a custom Exception.
     * @param inputMap Map&lt;Id, SObject&gt; to inspect.
     * @param key Required Id key.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;Id, SObject&gt;.
     * @throws Exception customException when inputMap is null or does not contain key.
     */
    public static Map<Id, SObject> containsKey(
        Map<Id, SObject> inputMap,
        Id key,
        Exception customException
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, customException);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; is non-null and contains the specified String key.
     * @param inputMap Map&lt;String, Object&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<String, Object> containsKey(
        Map<String, Object> inputMap,
        String key,
        String paramName
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; contains the specified String key with a custom message.
     * @param inputMap Map&lt;String, Object&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<String, Object> containsKey(
        Map<String, Object> inputMap,
        String key,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;String, Object&gt; contains the specified key, throwing a custom Exception.
     * @param inputMap Map&lt;String, Object&gt; to inspect.
     * @param key Required String key.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;String, Object&gt;.
     * @throws Exception customException when inputMap is null or does not contain key.
     */
    public static Map<String, Object> containsKey(
        Map<String, Object> inputMap,
        String key,
        Exception customException
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, customException);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; is non-null and contains the specified String key.
     * @param inputMap Map&lt;String, String&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Map&lt;String, String&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<String, String> containsKey(
        Map<String, String> inputMap,
        String key,
        String paramName
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; contains the specified String key with a custom message.
     * @param inputMap Map&lt;String, String&gt; to inspect.
     * @param key Required String key.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Map&lt;String, String&gt;.
     * @throws GuardException when inputMap is null or does not contain key.
     */
    public static Map<String, String> containsKey(
        Map<String, String> inputMap,
        String key,
        String paramName,
        String customMessage
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, paramName, customMessage);
    }

    /**
     * @description Ensures a Map&lt;String, String&gt; contains the specified key, throwing a custom Exception.
     * @param inputMap Map&lt;String, String&gt; to inspect.
     * @param key Required String key.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Map&lt;String, String&gt;.
     * @throws Exception customException when inputMap is null or does not contain key.
     */
    public static Map<String, String> containsKey(
        Map<String, String> inputMap,
        String key,
        Exception customException
    ) {
        return GuardCollectionValidator.containsKey(inputMap, key, customException);
    }

    // =========================================================================
    // 6. Salesforce-Native (Id, SObject, Schema)
    // =========================================================================

    /**
     * @description Validates that a String represents a valid 15- or 18-character Salesforce Id
     *              (including 18-character checksum verification via Id.valueOf).
     * @param value Candidate Salesforce Id string.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return Parsed Salesforce Id for single-line assignment.
     * @throws GuardException when value is blank or not a valid Salesforce Id.
     */
    public static Id isValidId(String value, String paramName) {
        return GuardSObjectValidator.isValidId(value, paramName);
    }

    /**
     * @description Validates that a String represents a valid Salesforce Id with a custom message.
     * @param value Candidate Salesforce Id string.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return Parsed Salesforce Id.
     * @throws GuardException when value is blank or not a valid Salesforce Id.
     */
    public static Id isValidId(String value, String paramName, String customMessage) {
        return GuardSObjectValidator.isValidId(value, paramName, customMessage);
    }

    /**
     * @description Validates that a String represents a valid Salesforce Id, throwing a custom Exception.
     * @param value Candidate Salesforce Id string.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return Parsed Salesforce Id.
     * @throws Exception customException when value is blank or not a valid Salesforce Id.
     */
    public static Id isValidId(String value, Exception customException) {
        return GuardSObjectValidator.isValidId(value, customException);
    }

    /**
     * @description Validates that a Salesforce Id is non-null and belongs to expectedType.
     * @param recordId Salesforce Id to validate.
     * @param expectedType Expected Schema.SObjectType token (e.g., Account.SObjectType).
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated Salesforce Id.
     * @throws GuardException when recordId is null or belongs to a different SObjectType.
     */
    public static Id isIdOfType(Id recordId, Schema.SObjectType expectedType, String paramName) {
        return GuardSObjectValidator.isIdOfType(recordId, expectedType, paramName);
    }

    /**
     * @description Validates that a Salesforce Id belongs to expectedType with a custom message.
     * @param recordId Salesforce Id to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated Salesforce Id.
     * @throws GuardException when recordId is null or belongs to a different SObjectType.
     */
    public static Id isIdOfType(
        Id recordId,
        Schema.SObjectType expectedType,
        String paramName,
        String customMessage
    ) {
        return GuardSObjectValidator.isIdOfType(recordId, expectedType, paramName, customMessage);
    }

    /**
     * @description Validates that a Salesforce Id belongs to expectedType, throwing a custom Exception.
     * @param recordId Salesforce Id to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated Salesforce Id.
     * @throws Exception customException when recordId is null or belongs to a different SObjectType.
     */
    public static Id isIdOfType(
        Id recordId,
        Schema.SObjectType expectedType,
        Exception customException
    ) {
        return GuardSObjectValidator.isIdOfType(recordId, expectedType, customException);
    }

    /**
     * @description Validates that an SObject instance is non-null and matches expectedType.
     * @param record SObject instance to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated SObject instance.
     * @throws GuardException when record is null or of a different SObjectType.
     */
    public static SObject isSObjectType(
        SObject record,
        Schema.SObjectType expectedType,
        String paramName
    ) {
        return GuardSObjectValidator.isSObjectType(record, expectedType, paramName);
    }

    /**
     * @description Validates that an SObject instance matches expectedType with a custom message.
     * @param record SObject instance to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated SObject instance.
     * @throws GuardException when record is null or of a different SObjectType.
     */
    public static SObject isSObjectType(
        SObject record,
        Schema.SObjectType expectedType,
        String paramName,
        String customMessage
    ) {
        return GuardSObjectValidator.isSObjectType(record, expectedType, paramName, customMessage);
    }

    /**
     * @description Validates that an SObject instance matches expectedType, throwing a custom Exception.
     * @param record SObject instance to validate.
     * @param expectedType Expected Schema.SObjectType token.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated SObject instance.
     * @throws Exception customException when record is null or of a different SObjectType.
     */
    public static SObject isSObjectType(
        SObject record,
        Schema.SObjectType expectedType,
        Exception customException
    ) {
        return GuardSObjectValidator.isSObjectType(record, expectedType, customException);
    }

    /**
     * @description Ensures a field is both set/queried in memory on the SObject and non-null.
     * @param record SObject record to inspect.
     * @param field Schema.SObjectField token to verify.
     * @param paramName Parameter name included in error messages and exception metadata.
     * @return The validated SObject instance.
     * @throws GuardException when record is null, field is unset, or field value is null.
     */
    public static SObject hasPopulatedField(
        SObject record,
        Schema.SObjectField field,
        String paramName
    ) {
        return GuardSObjectValidator.hasPopulatedField(record, field, paramName);
    }

    /**
     * @description Ensures a field is set/queried in memory and non-null on the SObject with a custom message.
     * @param record SObject record to inspect.
     * @param field Schema.SObjectField token to verify.
     * @param paramName Parameter name included in exception metadata.
     * @param customMessage Custom error message overriding the default diagnostic text.
     * @return The validated SObject instance.
     * @throws GuardException when record is null, field is unset, or field value is null.
     */
    public static SObject hasPopulatedField(
        SObject record,
        Schema.SObjectField field,
        String paramName,
        String customMessage
    ) {
        return GuardSObjectValidator.hasPopulatedField(record, field, paramName, customMessage);
    }

    /**
     * @description Ensures a field is set/queried and non-null on the SObject, throwing a custom Exception.
     * @param record SObject record to inspect.
     * @param field Schema.SObjectField token to verify.
     * @param customException Caller-provided Exception instance thrown on failure.
     * @return The validated SObject instance.
     * @throws Exception customException when record is null, field is unset, or field value is null.
     */
    public static SObject hasPopulatedField(
        SObject record,
        Schema.SObjectField field,
        Exception customException
    ) {
        return GuardSObjectValidator.hasPopulatedField(record, field, customException);
    }

    // =========================================================================
    // 7. Context, Trigger Record Builder & Extensibility Entry Points
    // =========================================================================

    /**
     * @description Creates a non-throwing fluent GuardRecord builder for the given SObject.
     *              Validation failures call record.addError(field, message) or record.addError(message),
     *              supporting Trigger bulkification, partial DML, and Lightning UI field highlighting.
     * @param record Non-null SObject instance to validate.
     * @return Fluent GuardRecord validator bound to record.
     * @throws GuardException when record itself is null.
     */
    public static GuardRecord onRecord(SObject record) {
        return new GuardRecord(record);
    }

    /**
     * @description Activates explicit LWC/Aura error handling so guard failures throw
     *              AuraHandledException with setMessage() invoked (avoiding "Script-thrown exception").
     *              Can be called as a standalone statement (`Guard.forLwc();`) or chained fluently
     *              (`Guard.forLwc().isNotBlank(val, 'val');`).
     * @return GuardContext.LwcScope fluent wrapper.
     */
    public static GuardContext.LwcScope forLwc() {
        return GuardContext.enableLwcMode();
    }

    /**
     * @description Disables explicit LWC mode activated by a prior Guard.forLwc() statement.
     */
    public static void disableLwcMode() {
        GuardContext.setLwcMode(false);
    }

    /**
     * @description Controls whether ApexGuard automatically throws AuraHandledException when
     *              System.Request.getCurrent().getQuiddity() equals System.Quiddity.AURA.
     * @param enabled True (default) to auto-detect Aura/LWC requests; false to require Guard.forLwc().
     */
    public static void setAutoDetectAuraQuiddity(Boolean enabled) {
        GuardContext.setAutoDetectAuraQuiddity(enabled);
    }

    /**
     * @description Registers a transaction-scoped failure handler (for example, Nebula Logger
     *              integration or domain exception translation).
     * @param handler Implementation of IGuardFailureHandler, or null to clear.
     */
    public static void setFailureHandler(IGuardFailureHandler handler) {
        GuardContext.setFailureHandler(handler);
    }

    /**
     * @description Clears the active IGuardFailureHandler for the current transaction.
     */
    public static void resetFailureHandler() {
        GuardContext.setFailureHandler(null);
    }

    /**
     * @description Resets all GuardContext configuration (failure handler, LWC flags, test overrides).
     */
    public static void resetContext() {
        GuardContext.reset();
    }
}
