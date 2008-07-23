
INCLUDE (CheckTypeSize)

#macro that sets OUTPUT as the value of oneof options (if _CL_HAVE_OPTION exists)
MACRO(CHOOSE_TYPE name size sign options)
    IF ( HAVE_SYS_TIMEB_H )
    	SET (CMAKE_EXTRA_INCLUDE_FILES "${CMAKE_EXTRA_INCLUDE_FILES};sys/timeb.h")
    ENDIF ( HAVE_SYS_TIMEB_H )
    IF ( HAVE_TCHAR_H )
    	SET (CMAKE_EXTRA_INCLUDE_FILES "${CMAKE_EXTRA_INCLUDE_FILES};tchar.h")
    ENDIF ( HAVE_TCHAR_H )

    STRING(TOUPPER ${name} NAME)
    FOREACH(option ${options})
        IF ( NOT TYPE_${NAME} )
            STRING(TOUPPER ${option} OPTION)
	        STRING(REPLACE " " "" OPTION ${OPTION})
	        STRING(REPLACE "_" "" SO_OPTION ${OPTION})
	        
	        _CHOOSE_STATUS(PROGRESS ${name} "type")
            CHECK_TYPE_SIZE(${option} _CL_HAVE_TYPE_${OPTION})
            IF ( _CL_HAVE_TYPE_${OPTION} )
                IF ( option STREQUAL ${name} )
    				#already have it, ignore this...
    				SET (TYPE_${NAME} "/* undef ${name} ${option} */" )
    			ELSE ( option STREQUAL ${name} )
    			    IF ( ${size} LESS 0 OR _CL_HAVE_TYPE_${OPTION} EQUAL ${size} )
        				SET (TYPE_${NAME} "typedef ${sign} ${option} ${name};")
        		    ENDIF ( ${size} LESS 0 OR _CL_HAVE_TYPE_${OPTION} EQUAL ${size})
    			ENDIF ( option STREQUAL ${name} )
    			
				IF ( NOT "${ARGV4}" STREQUAL "" )
					SET ( ${ARGV4} "${option}" )
				ENDIF ( NOT "${ARGV4}" STREQUAL "" )
				_CHOOSE_STATUS(END ${name} "type" ${option})
    	    ENDIF ( _CL_HAVE_TYPE_${OPTION} )	
    	ENDIF( NOT TYPE_${NAME} )
    ENDFOREACH(option ${options})
    
    IF ( NOT TYPE_${NAME} )
        SET (TYPE_${NAME} "/* undef ${name} */" )
        _CHOOSE_STATUS(END ${name} "type" "not found")
    ELSE ( NOT TYPE_${NAME} )
        SET (HAVE_TYPE_${NAME} 1)
    ENDIF ( NOT TYPE_${NAME} )
    
    
    SET(CMAKE_EXTRA_INCLUDE_FILES) 
ENDMACRO(CHOOSE_TYPE)