/***********************************************************************************

 * �� �� ��   : printStruct.em
 * �� �� ��   : jiangbo,����
 * ��������   : 2016��12��28��
 * �� �� ��   : 
 * �ļ�����   : ���ɴ�ӡ�ṹ��ĺ���
 * ��Ȩ˵��   : Copyright (C) 2000-2016   ���ͨ�ſƼ��ɷ����޹�˾
 * ��    ��   : ʹ��ʱ������printStruct�������Զ����key�ϣ���"ctrl+alt+s",����궨λ����Ҫ���ɽ�������Ľṹ�������ϣ�
                ��"ctrl+alt+s"���ɡ���һ��ʹ��ʱ����Ҫ�����ӡ�ĺ������֣���"printf"��"BMU_LOG"����ӡ�Ķ��������
                ��"int level"���Ժ���Ҫ�޸ģ����ڵ���һ������"co"��"config"���ٰ�"ctrl+alt+s"�޸�
 * �޸���־   : 

***********************************************************************************/

/*****************************************************************************
 * �� �� ��  : CheckIsSeparator
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : �ж��Ƿ��Ƿָ���
 * �������  : ch  �����ַ�
 * �������  : ��
 * �� �� ֵ  :     �Ƿ���true���񷵻�false
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsSeparator(ch)
{
    return (( ch == " ") || (ch == "\t")
            || ( ch == ":") || (ch == ".")
            || ( ch == ";") || (ch == "}")
            || ( ch == "{"))
}

/*****************************************************************************
 * �� �� ��  : PeelLastWord
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : �������һ������
 * �������  : szLine  ��Ҫ������ַ����������пո�������ָ�������������ע��
 * �������  : ��
 * �� �� ֵ  :         ������������һ�����ʺ�ʣ�µ��ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PeelLastWord(szLine)
{
    hword = nil
    ichRight = strlen(szLine)
    //msg("str=" # szLine #  "; len="  # ichRight)
    if(ichRight == 0)
    {
        return hword
    }
    ich = ichRight - 1
    while(ich > 0)
    {
        //msg("szLine[" # ich # "]=" # szLine[ich] # ";")
        if( CheckIsSeparator(szLine[ich]) )

        {
            ich = ich - 1
        }
        else
        {
            break
        }
    }
    ichRight = ich + 1
    while(ich >= 0)
    {    
        //msg("szLine[" # ich # "]=" # szLine[ich]  # ";")
        if( CheckIsSeparator(szLine[ich]) )
        {
            break
        }
        ich = ich - 1
    }
    ich = ich + 1
    
    hword.peelWord = strmid(szLine,ich,ichRight)
    hword.leftWord = strmid(szLine,0,ich)
    return hword
}

/*****************************************************************************
 * �� �� ��  : PeelFirstWord
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : �����һ������
 * �������  : szLine  ��Ҫ������ַ����������пո�������ָ�������������ע��
 * �������  : ��
 * �� �� ֵ  :         ��������ĵ�һ�����ʺ�ʣ�µ��ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PeelFirstWord(szLine)
{
    hword = nil
    //msg("#####" # szLine #  "#####"  # ichRight)
    len = strlen(szLine)
    if(len == 0)
    {
        return hword
    }
    ich = 0
    while(ich < len)
    {
        //msg("szLine[" # ich # "]=" # szLine[ich])
        if( CheckIsSeparator(szLine[ich]) )

        {
            ich = ich + 1
        }
        else
        {
            break
        }
    }
    ichLeft = ich
    while(ich < len)
    {
        //msg("szLine[" # ich # "]=" # szLine[ich])
        if( CheckIsSeparator(szLine[ich]) )
        {
            break
        }
        ich = ich + 1
    }
    
    hword.peelWord = strmid(szLine,ichLeft,ich)
    hword.leftWord = strmid(szLine,ich,len)
    return hword
}

/*****************************************************************************
 * �� �� ��  : CheckIsSignedKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ���signed����
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ���signed����
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsSignedKey(szWord)
{
    return ((szWord == "char")
            || (szWord == "short")
            || (szWord == "int")
            || (szWord == "long"))
}

/*****************************************************************************
 * �� �� ��  : CheckIsUnsignedKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ���unsigned����
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ���unsigned����
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsUnsignedKey(szWord)
{
    return ((szWord == "unsigned char")
            || (szWord == "unsigned short")
            || (szWord == "unsigned int")
            || (szWord == "unsigned long"))
}

/*****************************************************************************
 * �� �� ��  : CheckIsLongKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ���long����
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ���long����
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsLongKey(szWord)
{
    return ((szWord == "long")
            || (szWord == "unsigned long"))
}

/*****************************************************************************
 * �� �� ��  : CheckIsFuncPointKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ��Ǻ���ָ��
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ��Ǻ���ָ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsFuncPointKey(szWord)
{
    return (szWord == "functioPointer")
}

/*****************************************************************************
 * �� �� ��  : CheckIsPointKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ���ָ��
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ���ָ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsPointKey(szWord)
{
    return (szWord == "pointer")
}

/*****************************************************************************
 * �� �� ��  : CheckIsEnumKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ���ö������
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ���ö��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsEnumKey(szWord)
{
    return (szWord == "enum")
}


/*****************************************************************************
 * �� �� ��  : CheckIsKey
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ��ǹؼ���
 * �������  : szWord  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ��ǹؼ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsKey(szWord)
{
    return (CheckIsSignedKey(szWord) || CheckIsUnsignedKey(szWord))
}

/*****************************************************************************
 * �� �� ��  : GetPrintControlFormat
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ��ȡ��ͬ���͵Ĵ�ӡ���Ʒ�
 * �������  : szKeyWord  �ؼ���
 * �������  : ��
 * �� �� ֵ  :            ��ӡ���Ʒ�
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro GetPrintControlFormat(szKeyWord)
{
    var szCrlFmt
    
    szCrlFmt = nil
    
    if(CheckIsKey(szKeyWord))
    {
        szCrlFmt = "%"
        
        if(CheckIsLongKey(szKeyWord))
        {
            szCrlFmt = cat(szCrlFmt, "l")
        }
        
        if(CheckIsUnsignedKey(szKeyWord))
        {
            szCrlFmt = cat(szCrlFmt, "u")
        }
        else if(CheckIsSignedKey(szKeyWord))
        {
            szCrlFmt = cat(szCrlFmt, "d")
        }
        else
        {
            szCrlFmt = nil
        }
    }
    else if(CheckIsPointKey(szKeyWord) || CheckIsFuncPointKey(szKeyWord))
    {
        szCrlFmt = "%p"
    }
    else if(CheckIsEnumKey(szKeyWord))
    {
        szCrlFmt = "%d"
    }
    
    return szCrlFmt
}

/*****************************************************************************
 * �� �� ��  : PeelFisrtKeyWord
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : ����C���Ե�һ������KEY
 * �������  : szLine  ��Ҫ������ַ����������пո�������ָ�������������ע��
 * �������  : ��
 * �� �� ֵ  :         ��������ĵ�һ������KEY��ʣ�µ��ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PeelFisrtKeyWord(szLine)
{
    var hword
    var hwordTemp
    var szkeyWord

    szkeyWord = ""
    
    hwordTemp = PeelFirstWord(szLine)
    if(nil == hwordTemp)
    {
        return hword
    }

    if (hwordTemp.peelWord  == "unsigned")
    {
        szkeyWord = cat(hwordTemp.peelWord, " ")
        hwordTemp = PeelFirstWord(hwordTemp.leftWord)
    }

    if (CheckIsSignedKey(hwordTemp.peelWord))
    {
        szkeyWord = cat(szkeyWord, hwordTemp.peelWord)
        hword.peelWord = szkeyWord
        hword.leftWord = hwordTemp.leftWord
    }
    else
    {
        hword.peelWord = ""
        hword.leftWord = szLine
    }
    
    return hword
}

/*****************************************************************************
 * �� �� ��  : PeelLastKeyWord
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : ����C�������һ������KEY
 * �������  : szLine  ��Ҫ������ַ����������пո�������ָ�������������ע��
 * �������  : ��
 * �� �� ֵ  :         ������������һ������KEY��ʣ�µ��ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PeelLastKeyWord(szLine)
{
    var hword
    var hwordTemp
    var szkeyWord

    szkeyWord = ""
    
    hwordTemp = PeelLastWord(szLine)
    if(nil == hwordTemp)
    {
        return hword
    }

    if (CheckIsSignedKey(hwordTemp.peelWord))
    {
        szkeyWord = hwordTemp.peelWord
        hwordTemp = PeelLastWord(hwordTemp.leftWord)

        if(nil != hwordTemp)
        {
            hword.leftWord = hwordTemp.leftWord

            if (hwordTemp.peelWord  == "unsigned")
            {
                szkeyWord = cat("unsigned ", szkeyWord)
            }
        }
        else
        {
            hword.leftWord = ""
        }

        hword.peelWord = szkeyWord
    }
    else
    {
        hword.peelWord = ""
        hword.leftWord = szLine
    }
    
    return hword
}

/*****************************************************************************
 * �� �� ��  : CheckIsFuncPoint
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ����Ƿ��Ǻ���ָ��
 * �������  : szLine  �ַ���
 * �������  : ��
 * �� �� ֵ  :         �Ƿ��Ǻ���ָ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckIsFuncPoint(szLine)
{
    var len
    var ich

    len = strlen(szLine)
    if(len == 0)
    {
        return false
    }
    
    ich = 0
    while(ich < len)
    {
        if(szLine[ich] == "(")
        {
            ich = ich + 1
            while(ich < len)
            {
                if((szLine[ich] == " ") || (szLine[ich] == "\t"))
                {
                    ich = ich + 1
                }
                else if(szLine[ich] == "*")
                {
                    return true
                }
                else
                {
                    break;
                }
            }
        }
        else
        {
            ich = ich + 1
        }
    }

    return false
}

/*****************************************************************************
 * �� �� ��  : GetPeelLastWord
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : �������һ������
 * �������  : szLine  ��Ҫ������ַ����������пո�������ָ�����������ע��
 * �������  : ��
 * �� �� ֵ  :         ������������һ�����ʺ�ʣ�µ��ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro GetPeelLastWord(szLine)
{
    hword = nil
    RetVal = SkipCommentFromString(szLine, true)    /* ȥ��ע�� */
    szLineTmp = RetVal.szContent
    hword = PeelLastWord(szLineTmp)      /* ��ȡ���ĵ��� */

    return hword
}

/*****************************************************************************
 * �� �� ��  : CheckSymbolExist
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ��������SI���̺�ָ���ļ��Ƿ����
 * �������  : hbuf          �����ļ���
               szPreSymName  ���ŵ�ǰ׺
               szSymbolName  ���ŵ�����
 * �������  : ��
 * �� �� ֵ  :               �Ƿ����
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro CheckSymbolExist(hbuf, szPreSymName, szSymbolName)
{
    var symbolLoc
    var bufProps
    var ln
    var szLineTmp
    
    symbolLoc = GetSymbolLocation(szSymbolName)
    if(("" != symbolLoc) && ("Function" == symbolLoc.Type))
    {
        return true
    }
    
    bufProps = GetBufProps (hbuf)
    ln = 0
    while(ln < bufProps.lnCount)
    {
        szLineTmp = GetBufLine (hbuf, ln)
        ln = ln + 1
        ret = strstr(szLineTmp, szPreSymName # szSymbolName)
        if(0xffffffff != ret)
        {
            return true
        }
    }
    
    return false
}

/*****************************************************************************
 * �� �� ��  : TrimLeftCh
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ȥ���ַ�������ָ���ַ�
 * �������  : szLine  �ַ���
               ch      ��Ҫȥ�����ַ����������ַ���ʾÿ���ַ���Ҫȥ��
 * �������  : ��
 * �� �� ֵ  :         ȥ��ָ���ַ����ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro TrimLeftCh(szLine, ch)
{
    var nSzLen
    var nChLen
    var nSzIdx
    var nChIdx
    
    nSzLen = strlen(szLine)
    if(nSzLen == 0)
    {
        return szLine
    }

    nChLen = strlen(ch)
    if(nChLen == 0)
    {
        return szLine
    }

    nSzIdx = 0
    while( nSzIdx < nSzLen )
    {
        nChIdx = 0
        while( nChIdx < nChLen )
        {        
//            msg("szLine[" # nSzIdx # "]=\"" # szLine[nSzIdx] # "\";ch[" # nChIdx # "]=\"" # ch[nChIdx] # "\";")
            if( szLine[nSzIdx] == ch[nChIdx] )
            {
                break
            }            
            nChIdx = nChIdx + 1
        }
        if(nChIdx == nChLen)
        {
            break
        }
        
        nSzIdx = nSzIdx + 1
    }
//    msg(nSzIdx)
    return strmid(szLine,nSzIdx,nSzLen)
}

/*****************************************************************************
 * �� �� ��  : TrimRightCh
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ȥ���ַ����Ҳ��ָ���ַ�
 * �������  : szLine  �ַ���
               ch      ��Ҫȥ�����ַ����������ַ���ʾÿ���ַ���Ҫȥ��
 * �������  : ��
 * �� �� ֵ  :         ȥ��ָ���ַ����ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro TrimRightCh(szLine, ch)
{
    var nSzLen
    var nChLen
    var nSzIdx
    var nChIdx
    
    nSzLen = strlen(szLine)
    if(nSzLen == 0)
    {
        return szLine
    }

    nChLen = strlen(ch)
    if(nChLen == 0)
    {
        return szLine
    }

    nSzIdx = nSzLen - 1
    while( nSzIdx > 0 )
    {
        nChIdx = nChLen - 1
        while( nChIdx >= 0 )
        {        
//            msg("szLine[" # nSzIdx # "]=\"" # szLine[nSzIdx] # "\";ch[" # nChIdx # "]=\"" # ch[nChIdx] # "\";")
            if( szLine[nSzIdx] == ch[nChIdx] )
            {
                break
            }            
            nChIdx = nChIdx - 1
        }
        if(nChIdx < 0)
        {
            break
        }

        nSzIdx = nSzIdx - 1
    }
    
    nSzIdx = nSzIdx + 1
//    msg(nSzIdx)
    return strmid(szLine, 0, nSzIdx)
}


/*****************************************************************************
 * �� �� ��  : TrimBraket
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : �����ַ����ķ�����
 * �������  : sz  �ַ���
 * �������  : ��
 * �� �� ֵ  :      ����������"[]"���ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro TrimBraket(sz)
{
    sz = TrimString(sz)
    sz = TrimLeftCh(sz, "[")
    sz = TrimRightCh(sz, "]")

    return sz
}

/*****************************************************************************
 * �� �� ��  : GetArraySize
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ��������ķ����ź�ǰ��ո�
 * �������  : szLine  �ַ���
 * �������  : ��
 * �� �� ֵ  :         ����������"[]"���ַ���������������飬�򷵻�nil
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro GetArraySize(szLine)
{
    var szret

    szret = nil
    
    szLine = TrimString(szLine)            /* ȥ��ǰ��ո� */

    //���������ʶ"["
    if(szLine[0] == "[")
    {
    
        szLine = TrimRightCh(szLine, ";")   /* ȥ���ұߵķֺ� */
        szret = TrimBraket(szLine)          /* ȥ�������� */
    }

    return szret
}

/*****************************************************************************
 * �� �� ��  : PrintStructBasicMember
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ������ͨ���ͳ�Ա
 * �������  : hbuf               ������ļ�
               ln                 ������к�
               preBlank           ��ӡ֮ǰ����Ŀո�
               szPrintName        ��ӡ����������
               szPrintExtParm     ��ӡ�����Ķ������
               szPrintFmt         ��ӡ�ĸ�ʽ
               arraySize          �����С
               szStructParmName   �����Ľӿ�������
               szChildSymName     �ṹ���Ա������
               szChildSymNameLen  �ṹ���Ա���ֵĳ���
 * �������  : ��
 * �� �� ֵ  :                 ���֮������һ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PrintStructBasicMember(hbuf, ln, preBlank, szPrintName, szPrintExtParm, szPrintFmt, arraySize, szStructParmName, szChildSymName, szChildSymNameLen)
{
    var preBlankNew
    var hword

    if(szPrintExtParm != nil)
    {
        hword = PeelLastWord(szPrintExtParm)
        if(hword != nil)
        {
            szPrintExtParm = cat(hword.peelWord, ", ")
        }
    }

    if(arraySize == nil)
    {
        InsBufLine (hbuf, ln, preBlank # szPrintName # "(" # szPrintExtParm # "\"%-*s  " # szPrintFmt # "\\r\\n\", " # szChildSymNameLen # ", \"" # szChildSymName # "\", " # szStructParmName # "->" # szChildSymName  # ");")
        ln = ln + 1
    }
    else
    {
        preBlankNew = cat(preBlank, "    ")
        InsBufLine (hbuf, ln, preBlank # "{" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "int i = 0;" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "char buf[10 * (" # arraySize # " + 1) + 1];" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "char *p_buf = buf;" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "memset(buf, 0, sizeof(buf));" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "for (i = 0; i < " # arraySize # "; i++)" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "{" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "    sprintf(p_buf, \"" # szPrintFmt # ".\", " # szStructParmName # "->" # szChildSymName  # "[i]);")
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "    p_buf += strlen(p_buf);" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "}" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # szPrintName # "(" # szPrintExtParm # "\"%-*s  %s\\r\\n\", " # szChildSymNameLen # ", \"" # szChildSymName # "\", buf);" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlank # "}" )                    
        ln = ln + 1
    }

    return ln
}

/*****************************************************************************
 * �� �� ��  : PrintStructStructMember
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : �����ṹ���Ա
 * �������  : hbuf                         ������ļ�
               ln                           ������к�
               preBlank                     ��ӡ֮ǰ����Ŀո�
               arraySize                    �����С
               szAnalyzeStructFunctionName  �ṹ���Ա�����ĺ�����
               szStructParmName             �����Ľӿ�������
               szChildSymName               �ṹ���Ա������
 * �������  : ��
 * �� �� ֵ  :                 ���֮������һ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PrintStructStructMember(hbuf, ln, preBlank, arraySize, szAnalyzeStructFunctionName, szStructParmName, szChildSymName)
{
    var preBlankNew

    if(arraySize == nil)
    {
        InsBufLine (hbuf, ln, preBlank # szAnalyzeStructFunctionName # "(&(" # szStructParmName # "->" # szChildSymName  # "));")
        ln = ln + 1
    }
    else
    {
        preBlankNew = cat(preBlank, "    ")
        InsBufLine (hbuf, ln, preBlank # "{" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "int i = 0;" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "for (i = 0; i < " # arraySize # "; i++)" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "{" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "    " # szAnalyzeStructFunctionName # "(&(" # szStructParmName # "->" # szChildSymName  # "));")
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlankNew # "}" )
        ln = ln + 1
        InsBufLine (hbuf, ln, preBlank # "}" )
        ln = ln + 1
    }
    
    return ln
}

/*****************************************************************************
 * �� �� ��  : GetStructMember
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : �����ṹ���Ա
 * �������  : hOutbuf           ������ļ�
               ln                ������к�
               preBlank          ��ӡ֮ǰ����Ŀո�
               szPrintName       ��ӡ����������
               szPrintExtParm    ��ӡ�����Ķ������
               szStructParmName  �����Ľӿ�������
               symbolLocation    ���ű�
 * �������  : ��
 * �� �� ֵ  :                 ���֮������һ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro GetStructMember(hbuf, ln, preBlank, szPrintName, szPrintExtParm, szStructParmName, symbolLocation)
{
    var hsyml
    var cchild
    var ichild
    var childsym
    var szSymbol
    var szSymTmp
    var hword
    var symLocTmp
    var ich
    var szChildSymName
    var szPrint
    var hAnalyzeSymbol
    var arraySize
    var preBlankNew
    var szChildSymNameLen
    var childSymNameLen
    var lnFirst

    szChildSymNameLen = cat(toupper(szStructParmName), "_NAME_LEN")
    childSymNameLen = 0
    lnFirst = ln
    
    hsyml = SymbolChildren(symbolLocation)
    cchild = SymListCount(hsyml)
    ichild = 0
    while (ichild < cchild)
    {
        childsym = SymListItem(hsyml, ichild)
        //Msg (childsym.symbol # " was found in " # childsym.file # " at line " # childsym.lnFirst)
//        Msg ("11111 " # childsym)

        /* ��ȡ�ṹ���Ա������ */
        szSymbol = makeSymbolOneLine(childsym)       /* �õ�ƴ��һ�еĽṹ���Ա���� */
        hword = PeelLastWord(childsym.Symbol)       /* �ṹ���Ա��symbol��"�ṹ����.�ṹ���Ա",����Ҫ��ȡ.����� */
        szChildSymName = hword.peelWord

        /* ��ȡ�ṹ���Ա���ֵ��ֵ */
        if(childSymNameLen < strlen(szChildSymName))
        {
            childSymNameLen = strlen(szChildSymName)
        }
        
        ich = strstr(szSymbol, szChildSymName)
        if(0xffffffff == ich)
        {
            InsBufLine (hbuf, ln, preBlank # "//struct member name:" # childsym.Symbol # " not found!")
            ln = ln + 1
            
            ichild = ichild + 1
            continue
        }

        szSymTmp = strmid(szSymbol, ich + strlen(szChildSymName), strlen(szSymbol)) /* ��ȡ�ṹ���Ա��������ַ��� */
        arraySize = GetArraySize(szSymTmp)            
        
        szSymTmp = strmid(szSymbol,0,ich)          /* ��ȡ�ṹ���Ա��ǰ����ַ��������ṹ���Ա������ */
        szSymTmp = TrimString(szSymTmp)            /* ȥ��ǰ��ո� */
        if("" == szSymTmp)      /* source inside ��ʶ��Ľṹ���Ա */
        {
            InsBufLine (hbuf, ln, preBlank # "//struct member name:" # childsym.Symbol # " not has type!")
            ln = ln + 1

            ichild = ichild + 1
            continue
        }


        /* �����Ƿ���ָ�� */
        if(szSymTmp[strlen(szSymTmp) - 1] == "*")
        {
            ln = PrintStructBasicMember(hbuf, ln, preBlank, szPrintName, szPrintExtParm, "%p", arraySize, szStructParmName, szChildSymName, szChildSymNameLen)

            ichild = ichild + 1
            continue
        }
                
        /* ����typedef�Ƿ����˻������� */
        hword = PeelLastKeyWord(szSymTmp)                      /* �����C���ԵĻ���KEY */
        if(CheckIsKey(hword.peelWord))
        {
//            Msg(szSymbol # " find key word:" # hword.peelWord)
            szPrint = GetPrintControlFormat(hword.peelWord)
            if(szPrint == nil)
            {
                InsBufLine (hbuf, ln, preBlank # "//" # szStructParmName # "->" # szChildSymName # " unknown formart, key word:" # hword.peelWord)
                ln = ln + 1
            }
            else
            {
                ln = PrintStructBasicMember(hbuf, ln, preBlank, szPrintName, szPrintExtParm, szPrint, arraySize, szStructParmName, szChildSymName, szChildSymNameLen)
            }
            
            ichild = ichild + 1
            continue
        }

        /* ���������һ������ */
        hword = PeelLastWord(szSymTmp)
//        msg("2222 " # hword)
        symLocTmp = GetSymbolLocation(hword.peelWord)
        hAnalyzeSymbol = ProcessSymbol(hbuf, ln, szPrintName, szPrintExtParm, symLocTmp, nil)
        if(nil == hAnalyzeSymbol)
        {
            InsBufLine (hbuf, ln, preBlank # "//" # szStructParmName # "->" # szChildSymName # " unknown symbol:" # symLocTmp)
            ln = ln + 1
        }
        else
        {
            if("Basic key" == hAnalyzeSymbol.type)
            {
                szPrint = GetPrintControlFormat(hAnalyzeSymbol.basicKey)
                if(szPrint == nil)
                {
                    InsBufLine (hbuf, ln, preBlank # "//" # szStructParmName # "->" # szChildSymName # " unknown formart, key word:" # hword.peelWord)
                    ln = ln + 1
                }
                else
                {                    
                    ln = PrintStructBasicMember(hbuf, ln, preBlank, szPrintName, szPrintExtParm, szPrint, arraySize, szStructParmName, szChildSymName, szChildSymNameLen)
                }
            }
            else if ("Structure" == hAnalyzeSymbol.type)
            {
                ln = PrintStructStructMember(hbuf, ln, preBlank, arraySize, hAnalyzeSymbol.analyzeStructFunctionName, szStructParmName, szChildSymName)
            }
            else
            {
                InsBufLine (hbuf, ln, preBlank # "//" # szStructParmName # "->" # szChildSymName # " unknown formart, key word:" # hword.peelWord)
                ln = ln + 1
            }
        }

        ichild = ichild + 1
    }
    SymListFree(hsyml)

    /* #define�ṹ���Ա���ֵ��ֵ */
    InsBufLine (hbuf, lnFirst, preBlank # "#define " # szChildSymNameLen # " " # childSymNameLen)
    ln = ln + 1
    InsBufLine (hbuf, lnFirst + 1, "")
    ln = ln + 1
    InsBufLine (hbuf, ln, "")
    ln = ln + 1
    InsBufLine (hbuf, ln, preBlank # "#undef " # szChildSymNameLen)
    ln = ln + 1

    return ln
}

/*****************************************************************************
 * �� �� ��  : makeSymbolOneLine
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��29��
 * ��������  : ������ƴ��һ�У�ȥ��ע�ͣ�ȥ������Ŀո�������֮���һ���ո�
 * �������  : symbolLocation  ����
 * �������  : ��
 * �� �� ֵ  :                 ƴ��һ�еķ����ַ���
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro makeSymbolOneLine(symbolLocation)
{
    szSymbol = ""
    if(strlen(symbolLocation) == 0)
    {
       return szSymbol
    }

    hbuf = GetBufHandle(symbolLocation.File)             /* ��ȡ�������ڵ��ļ� */
    ln = symbolLocation.lnFirst
    fIsCommentEnd = true
    while(ln < symbolLocation.lnLim)
    {
        szLine = GetBufLine (hbuf, ln)    /* ��ȡ��ǰ�е��ַ� */
        RetVal = SkipCommentFromString(szLine,fIsCommentEnd)    /* ȥ��ע�͵����� */
        szLine = RetVal.szContent
        szLine = TrimString(szLine) /* ȥ���ո� */
	    fIsCommentEnd = RetVal.fIsEnd
        szSymbol = cat(szSymbol,szLine)
        szSymbol = cat(szSymbol," ")
        ln = ln + 1
    }
    
    return szSymbol
}

/*****************************************************************************
 * �� �� ��  : ProcessSymbol
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ������ű�
 * �������  : hOutbuf         ������ļ�
               ln              ������к�
               szPrintName     ��ӡ����������
               szPrintExtParm  ��ӡ�����Ķ������
               symbolLocation  ���ű�
               typedefName     typedef������
 * �������  : ��
 * �� �� ֵ  :                 ��������
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro ProcessSymbol(hOutbuf, ln, szPrintName, szPrintExtParm, symbolLocation, typedefName)
{
    var hAnalyzeSymbol
    var hword
    var szSymbol
    var szSymbolTemp
    var symLocTmp
    var ich
    var szGetStruct
    var szGetStructName
    var szGetStructFile
    var hChildBuf
    var hChildLn
    var childBufProps
    var szLineTmp
    var preBlank
    var szStructParmName

    hAnalyzeSymbol = nil
    
    if (symbolLocation == nil)
    {
        Msg ("not found symbol")
        return hAnalyzeSymbol
    }

//    Msg(symbolLocation)

    if (symbolLocation.Type == "Constant")
    {
        szSymbol = makeSymbolOneLine(symbolLocation)       /* ƴ��һ�� */
        /* ȥ���������ֺ�����ǰ�沿�֣����µľ���#define��ֵ */
        ich = strstr(szSymbol, " " # symbolLocation.Symbol)
        if(0xffffffff == ich)
        {
            Msg("symbol name:" # symbolLocation.Symbol # " not found!")
            stop
        }
        szSymbolTemp = strmid(szSymbol, ich + strlen(symbolLocation.Symbol), strlen(szSymbol))

        szSymbolTemp = TrimString(szSymbolTemp)

        Msg("define vlalue: " # szSymbolTemp)

        hAnalyzeSymbol.type = "Constant"
        hAnalyzeSymbol.defineValue = szSymbolTemp
        return hAnalyzeSymbol
    }
    if (symbolLocation.Type == "Type Definition")   /* ��typedef���ҵ������ķ��� */
    {
        szSymbol = makeSymbolOneLine(symbolLocation)       /* ƴ��һ�� */

        /* ȥ���������֣������������ֺ��沿�� */
        ich = strstr(szSymbol, symbolLocation.Symbol)
        if(0xffffffff == ich)
        {
            Msg("symbol name:" # symbolLocation.Symbol # " not found!")
            stop
        }
        szSymbolTemp = strmid(szSymbol,0,ich)          /* ��ȡ��������ǰ����ַ����������ŵ����� */


        /* ȥ����һ��typedef���� */
        hword = PeelFirstWord(szSymbolTemp)
        if(nil == hword)
        {
            Msg("no fisrt word!")
            return hAnalyzeSymbol
        }
        if(hword.peelWord != "typedef")     /* ��һ�����ʱض���typedef */
        {
            Msg("fisrt word is not \"typedef\"!")
            return hAnalyzeSymbol
        }
        szSymbolTemp = hword.leftWord

        /* �����Ƿ��Ǻ���ָ�� */
        if(CheckIsFuncPoint(szSymbolTemp))
        {
            Msg("find key word: function pointer")
            
            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = "functioPointer"
            return hAnalyzeSymbol
        }

        /* �����Ƿ���ָ�� */
        szSymbolTemp = TrimRight(szSymbolTemp)
        if(szSymbolTemp[strlen(szSymbolTemp) - 1] == "*")
        {
            Msg("find key word: pointer")

            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = "pointer"
            return hAnalyzeSymbol
        }

        /* ����typedef�Ƿ����˻������� */
        hword = PeelFisrtKeyWord(szSymbolTemp)                      /* �����C���ԵĻ���KEY */
//        Msg(hword)
        if(CheckIsKey(hword.peelWord))
        {
//            Msg("find key word:" # hword.peelWord)

            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = hword.peelWord
            return hAnalyzeSymbol
        }

        /* ����typedef֮��ĵ�һ������ */
        hword = PeelFirstWord(szSymbolTemp)
        if(hword.peelWord == "struct")
        {
            hword = PeelFirstWord(hword.leftWord)
            symLocTmp = GetSymbolLocation(hword.peelWord)
            hAnalyzeSymbol = ProcessSymbol(hOutbuf, ln, szPrintName, szPrintExtParm, symLocTmp, symbolLocation.Symbol)
        }
        else if(hword.peelWord == "enum")
        {
            Msg("find key word:enum")

            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = "enum"
            return hAnalyzeSymbol
        }
        else
        {
            Msg("unknown type:" # hword.peelWord)
            stop
        }
    }
    else if (symbolLocation.Type == "Structure")    /* �ǽṹ��ͱ�����Ա */
    {
        if(nil != typedefName)
        {
            szParmName = typedefName
            szPreParmName = ""
        }
        else
        {
            szParmName = symbolLocation.Symbol
            szPreParmName = "struct "
        }
        szGetStructName = cat("analyze_struct_", szParmName)
        szGetStructFile = cat(szGetStructName, ".c")

        szStructParmName = cat("p_", tolower(szParmName))
        szGetStruct = cat("void " # szGetStructName,
            "(" # szPrintExtParm # ", " # szPreParmName # szParmName # " *" # szStructParmName # ")")

        // ����szGetStruct�����Ƿ�ʵ�֣����ʵ������Ҫ���
        if(!CheckSymbolExist(hOutbuf, "void " , szGetStructName))
        {
            InsBufLine(hOutbuf, ln, szGetStruct)
            ln = ln + 1
            InsBufLine(hOutbuf, ln, "{")
            ln = ln + 1

            preBlank = "    "

            InsBufLine(hOutbuf, ln, preBlank # "if(NULL == " # szStructParmName # ")")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, preBlank # "{")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, preBlank # preBlank # "return;")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, preBlank # "}")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, "")
            ln = ln + 1
            
    //        hChildBuf = NewBuf (symbolLocation.Symbol # "member.c")
            /* ������Ա */
            ln = GetStructMember(hOutbuf, ln, preBlank, szPrintName, szPrintExtParm, szStructParmName, symbolLocation)
    //        childBufProps = GetBufProps (hChildBuf)
    //        hChildLn = 0
    //        while(hChildLn < childBufProps.lnCount)
    //        {
    //            szLineTmp = GetBufLine (hChildBuf, hChildLn)

    //            InsBufLine(hOutbuf, ln, preBlank # szLineTmp)
    //            ln = ln + 1

    //            hChildLn = hChildLn + 1
    //        }
    //        CloseBuf(hChildBuf)

            InsBufLine(hOutbuf, ln, "")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, preBlank # "return;")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, "}")
            ln = ln + 1
            InsBufLine(hOutbuf, ln, "")
            ln = ln + 1
        }        

        hAnalyzeSymbol.type = "Structure"
        hAnalyzeSymbol.analyzeStructFunctionName = szGetStructName
    }

    return hAnalyzeSymbol
}

/*****************************************************************************
 * �� �� ��  : SetPrintEnv
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ���ô�ӡ�����Ļ�������
 * �������  : ��
 * �������  : ��
 * �� �� ֵ  :   ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro SetPrintEnv()
{
    var szPrintName
    var szPrintExtParm

    szPrintName = Ask("Enter your print function name:")
    setreg("PRINTNAME", szPrintName)

    if(szPrintName == "printf")
    {
        szPrintExtParm = ""
    }
    else
    {
        szPrintExtParm = Ask("Enter your print function extern Parameter:")
        if((szPrintExtParm == "null") || (szPrintExtParm == "#"))
        {
            szPrintExtParm = ""
        }
    }
    setreg("PRINTEXTPARM", szPrintExtParm)

    return
}

/*****************************************************************************
 * �� �� ��  : GetPrintEnv
 * �� �� ��  : jiangbo,����
 * ��������  : 2017��1��4��
 * ��������  : ��ӡ�����Ļ�������
 * �������  : ��
 * �������  : ��
 * �� �� ֵ  : hPrintEnv.szPrintName��ӡ���������� hPrintEnv.szPrintExtParm��ӡ�����Ķ������(������)
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro GetPrintEnv()
{
    var hPrintEnv

    hPrintEnv.szPrintName = getreg("PRINTNAME")
    hPrintEnv.szPrintExtParm = getreg("PRINTEXTPARM")

    return hPrintEnv
}

/*****************************************************************************
 * �� �� ��  : PrintStruct
 * �� �� ��  : jiangbo,����
 * ��������  : 2016��12��28��
 * ��������  : ���ɴ�ӡ�ṹ�����ݵĺ���
 * �������  : ��
 * �������  : ��
 * �� �� ֵ  :   ��
 * ���ù�ϵ  : 
 * ��    ��  : 

*****************************************************************************/
macro PrintStruct()
{
//    printStructTest()

    var hOutbuf
    var ln
    var symbolLocation
    var hwnd
    var hbuf
    var sel
    var hPrintEnv
    
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)

    szLine = GetBufLine(hbuf, sel.lnFirst)
    szLine = TrimString(szLine)
    if((szLine == "co") || (szLine == "config"))
    {
        DelBufLine(hbuf, sel.lnFirst)
        SetPrintEnv()
        return
    }

    hOutbuf = NewBuf("analyze_stuct.c") // create output buffer
    if (hOutbuf == hnil)
        stop
    SetCurrentBuf(hOutbuf)

    ln = 0

    hPrintEnv = GetPrintEnv()
    if((hPrintEnv.szPrintName == nil) || (hPrintEnv.szPrintExtParm == nil))
    {
        SetPrintEnv()
    }
    hPrintEnv = GetPrintEnv()

    /* �ж��Ƿ���� */
    symbolLocation = GetSymbolFromCursor(hbuf, sel.lnFirst, sel.ichFirst)

    ProcessSymbol(hOutbuf, ln, hPrintEnv.szPrintName, hPrintEnv.szPrintExtParm, symbolLocation, nil)

}

macro printStructTest()
{
    szLine = TrimBraket("[{fdsl}]")
    
    msg(szLine)
    stop
}
