*** Settings ***
Library           XML
Resource          xml_resource.robot
Test Setup        Remove File    ${OUTPUT}
Suite Teardown    Remove File    ${OUTPUT}

*** Variables ***
${NON-ASCII}    <hyvää>yötä</hyvää>

*** Test Cases ***
Save XML Element
    ${xml} =    Parse XML    ${SIMPLE}
    Save XML    ${xml}    ${OUTPUT}
    XML Content Should Be    ${SIMPLE}

Save XML String
    Save XML    ${SIMPLE}    ${OUTPUT}
    XML Content Should Be    ${SIMPLE}

Save XML File
    Save XML    ${TEST}    ${OUTPUT}
    Elements Should Be Equal    ${TEST}    ${OUTPUT}

Save XML Using Custom Encoding
    Save XML    ${SIMPLE}    ${OUTPUT}    encoding=US-ASCII
    XML Content Should Be    ${SIMPLE}    encoding=US-ASCII

Save Non-ASCII XML
    Save XML    ${NON-ASCII}    ${OUTPUT}
    XML Content Should Be    ${NON-ASCII}

Save Non-ASCII XML Using Custom Encoding
    Save XML    ${NON-ASCII}    ${OUTPUT}    ISO-8859-1
    XML Content Should Be    ${NON-ASCII}    ISO-8859-1

Save to Invalid File
    [Documentation]    FAIL STARTS: IOError:
    Save XML    ${SIMPLE}    %{TEMPDIR}

Save Using Invalid Encoding
    [Documentation]    FAIL STARTS: LookupError:
    Save XML    ${SIMPLE}    ${OUTPUT}    encoding=invalid

Save Non-ASCII Using ASCII
    [Documentation]    FAIL STARTS: UnicodeEncodeError:
    Save XML    ${NON-ASCII}    ${OUTPUT}    ASCII

Doctype is not preserved
    Save XML    <!DOCTYPE foo><foo/>    ${OUTPUT}
    XML Content Should Be    <foo />
    Save XML    <!DOCTYPE bar SYSTEM "bar.dtd">\n<bar>baari</bar>    ${OUTPUT}
    XML Content Should Be    <bar>baari</bar>

Comments and processing instructions are removed
    ${xml} =    Replace String    ${SIMPLE}    <    <!--c--><?p?><
    ${xml} =    Replace String    ${xml}    >    ><!--c--><?p?>
    Save XML    ${xml}    ${OUTPUT}
    XML Content Should Be    ${SIMPLE}