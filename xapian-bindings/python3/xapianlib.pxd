# -*- python -*-

from libcpp.string cimport string

cdef extern from "xapian.h" namespace "Xapian":
    int major_version()
    int minor_version()
    int revision()
    char * version_string()

    cdef cppclass TermGenerator:
        # Default constructor.
        TermGenerator()

        string get_description()

"""
    /// Set the Xapian::Stem object to be used for generating stemmed terms.
    void set_stemmer(const Xapian::Stem & stemmer);

    /** Set the Xapian::Stopper object to be used for identifying stopwords.
     *
     *  Stemmed forms of stopwords aren't indexed, but unstemmed forms still
     *  are so that searches for phrases including stop words still work.
     *
     *  @param stop	The Stopper object to set (default NULL, which means no
     *			stopwords).
     */
    void set_stopper(const Xapian::Stopper *stop = NULL);

    /// Set the current document.
    void set_document(const Xapian::Document & doc);

    /// Get the current document.
    const Xapian::Document & get_document() const;

    /// Set the database to index spelling data to.
    void set_database(const Xapian::WritableDatabase &db);

    /// Flags to OR together and pass to TermGenerator::set_flags().
    enum flags {
	/// Index data required for spelling correction.
	FLAG_SPELLING = 128 // Value matches QueryParser flag.
    };

    /// Stemming strategies, for use with set_stemming_strategy().
    typedef enum { STEM_NONE, STEM_SOME, STEM_ALL, STEM_ALL_Z } stem_strategy;

    /** Set flags.
     *
     *  The new value of flags is: (flags & mask) ^ toggle
     *
     *  To just set the flags, pass the new flags in toggle and the
     *  default value for mask.
     *
     *  @param toggle	Flags to XOR.
     *  @param mask	Flags to AND with first.
     *
     *  @return		The old flags setting.
     */
    flags set_flags(flags toggle, flags mask = flags(0));

    /** Set the stemming strategy.
     *
     *  This method controls how the stemming algorithm is applied.  It was
     *  new in Xapian 1.3.1.
     *
     *  @param strategy	The strategy to use - possible values are:
     *   - STEM_NONE:	Don't perform any stemming - only unstemmed terms
     *			are generated.
     *   - STEM_SOME:	Generate both stemmed (with a "Z" prefix) and unstemmed
     *			terms.  This is the default strategy.
     *   - STEM_ALL:	Generate only stemmed terms (but without a "Z" prefix).
     *   - STEM_ALL_Z:	Generate only stemmed terms (with a "Z" prefix).
     */
    void set_stemming_strategy(stem_strategy strategy);

    /** Index some text.
     *
     * @param itor	Utf8Iterator pointing to the text to index.
     * @param wdf_inc	The wdf increment (default 1).
     * @param prefix	The term prefix to use (default is no prefix).
     */
    void index_text(const Xapian::Utf8Iterator & itor,
		    Xapian::termcount wdf_inc = 1,
		    const std::string & prefix = std::string());

    /** Index some text in a std::string.
     *
     * @param text	The text to index.
     * @param wdf_inc	The wdf increment (default 1).
     * @param prefix	The term prefix to use (default is no prefix).
     */
    void index_text(const std::string & text,
		    Xapian::termcount wdf_inc = 1,
		    const std::string & prefix = std::string()) {
	return index_text(Utf8Iterator(text), wdf_inc, prefix);
    }

    /** Index some text without positional information.
     *
     * Just like index_text, but no positional information is generated.  This
     * means that the database will be significantly smaller, but that phrase
     * searching and NEAR won't be supported.
     *
     * @param itor	Utf8Iterator pointing to the text to index.
     * @param wdf_inc	The wdf increment (default 1).
     * @param prefix	The term prefix to use (default is no prefix).
     */
    void index_text_without_positions(const Xapian::Utf8Iterator & itor,
				      Xapian::termcount wdf_inc = 1,
				      const std::string & prefix = std::string());

    /** Index some text in a std::string without positional information.
     *
     * Just like index_text, but no positional information is generated.  This
     * means that the database will be significantly smaller, but that phrase
     * searching and NEAR won't be supported.
     *
     * @param text	The text to index.
     * @param wdf_inc	The wdf increment (default 1).
     * @param prefix	The term prefix to use (default is no prefix).
     */
    void index_text_without_positions(const std::string & text,
				      Xapian::termcount wdf_inc = 1,
				      const std::string & prefix = std::string()) {
	return index_text_without_positions(Utf8Iterator(text), wdf_inc, prefix);
    }

    /** Increase the term position used by index_text.
     *
     *  This can be used between indexing text from different fields or other
     *  places to prevent phrase searches from spanning between them (e.g.
     *  between the title and body text, or between two chapters in a book).
     *
     *  @param delta	Amount to increase the term position by (default: 100).
     */
    void increase_termpos(Xapian::termcount delta = 100);

    /// Get the current term position.
    Xapian::termcount get_termpos() const;

    /** Set the current term position.
     *
     *  @param termpos	The new term position to set.
     */
    void set_termpos(Xapian::termcount termpos);

    /// Return a string describing this object.
    std::string get_description() const;
"""
