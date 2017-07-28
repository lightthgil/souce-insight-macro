/***********************************************************************************

 * 文 件 名   : printStruct.em
 * 负 责 人   : jiangbo,蒋博
 * 创建日期   : 2016年12月28日
 * 版 本 号   : 
 * 文件描述   : 生成打印结构体的函数
 * 版权说明   : Copyright (C) 2000-2016   烽火通信科技股份有限公司
 * 其    他   : 使用时，将宏printStruct关联到自定义的key上，如"ctrl+alt+s",将光标定位到需要生成解析代码的结构体名称上，
                按"ctrl+alt+s"即可。第一次使用时，需要输入打印的函数名字，如"printf"或"BMU_LOG"，打印的额外参数，
                如"int level"，以后需要修改，请在单独一行输入"co"或"config"，再按"ctrl+alt+s"修改
 * 修改日志   : 

***********************************************************************************/

/*****************************************************************************
 * 函 数 名  : CheckIsSeparator
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 判断是否是分隔符
 * 输入参数  : ch  单个字符
 * 输出参数  : 无
 * 返 回 值  :     是返回true，否返回false
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsSeparator(ch)
{
    return (( ch == " ") || (ch == "\t")
            || ( ch == ":") || (ch == ".")
            || ( ch == ";") || (ch == "}")
            || ( ch == "{"))
}

/*****************************************************************************
 * 函 数 名  : PeelLastWord
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 分离最后一个单词
 * 输入参数  : szLine  需要分离的字符串，允许有空格或其他分隔符，不允许有注释
 * 输出参数  : 无
 * 返 回 值  :         分离出来的最后一个单词和剩下的字符串
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : PeelFirstWord
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 分离第一个单词
 * 输入参数  : szLine  需要分离的字符串，允许有空格或其他分隔符，不允许有注释
 * 输出参数  : 无
 * 返 回 值  :         分离出来的第一个单词和剩下的字符串
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : CheckIsSignedKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是signed类型
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是signed类型
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsSignedKey(szWord)
{
    return ((szWord == "char")
            || (szWord == "short")
            || (szWord == "int")
            || (szWord == "long"))
}

/*****************************************************************************
 * 函 数 名  : CheckIsUnsignedKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是unsigned类型
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是unsigned类型
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsUnsignedKey(szWord)
{
    return ((szWord == "unsigned char")
            || (szWord == "unsigned short")
            || (szWord == "unsigned int")
            || (szWord == "unsigned long"))
}

/*****************************************************************************
 * 函 数 名  : CheckIsLongKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是long类型
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是long类型
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsLongKey(szWord)
{
    return ((szWord == "long")
            || (szWord == "unsigned long"))
}

/*****************************************************************************
 * 函 数 名  : CheckIsFuncPointKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是函数指针
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是函数指针
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsFuncPointKey(szWord)
{
    return (szWord == "functioPointer")
}

/*****************************************************************************
 * 函 数 名  : CheckIsPointKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是指针
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是指针
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsPointKey(szWord)
{
    return (szWord == "pointer")
}

/*****************************************************************************
 * 函 数 名  : CheckIsEnumKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是枚举类型
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是枚举
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsEnumKey(szWord)
{
    return (szWord == "enum")
}


/*****************************************************************************
 * 函 数 名  : CheckIsKey
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是关键字
 * 输入参数  : szWord  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是关键字
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro CheckIsKey(szWord)
{
    return (CheckIsSignedKey(szWord) || CheckIsUnsignedKey(szWord))
}

/*****************************************************************************
 * 函 数 名  : GetPrintControlFormat
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 获取不同类型的打印控制符
 * 输入参数  : szKeyWord  关键字
 * 输出参数  : 无
 * 返 回 值  :            打印控制符
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : PeelFisrtKeyWord
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 分离C语言第一个基础KEY
 * 输入参数  : szLine  需要分离的字符串，允许有空格或其他分隔符，不允许有注释
 * 输出参数  : 无
 * 返 回 值  :         分离出来的第一个基础KEY和剩下的字符串
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : PeelLastKeyWord
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 分离C语言最后一个基础KEY
 * 输入参数  : szLine  需要分离的字符串，允许有空格或其他分隔符，不允许有注释
 * 输出参数  : 无
 * 返 回 值  :         分离出来的最后一个基础KEY和剩下的字符串
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : CheckIsFuncPoint
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查是否是函数指针
 * 输入参数  : szLine  字符串
 * 输出参数  : 无
 * 返 回 值  :         是否是函数指针
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : GetPeelLastWord
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 分离最后一个单词
 * 输入参数  : szLine  需要分离的字符串，允许有空格或其他分隔符，允许有注释
 * 输出参数  : 无
 * 返 回 值  :         分离出来的最后一个单词和剩下的字符串
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro GetPeelLastWord(szLine)
{
    hword = nil
    RetVal = SkipCommentFromString(szLine, true)    /* 去除注释 */
    szLineTmp = RetVal.szContent
    hword = PeelLastWord(szLineTmp)      /* 获取左侧的单词 */

    return hword
}

/*****************************************************************************
 * 函 数 名  : CheckSymbolExist
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 检查符号在SI工程和指定文件是否存在
 * 输入参数  : hbuf          检查的文件名
               szPreSymName  符号的前缀
               szSymbolName  符号的名字
 * 输出参数  : 无
 * 返 回 值  :               是否存在
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : TrimLeftCh
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 去掉字符串左侧的指定字符
 * 输入参数  : szLine  字符串
               ch      需要去掉的字符，输入多个字符表示每个字符都要去掉
 * 输出参数  : 无
 * 返 回 值  :         去掉指定字符的字符串
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : TrimRightCh
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 去掉字符串右侧的指定字符
 * 输入参数  : szLine  字符串
               ch      需要去掉的字符，输入多个字符表示每个字符都要去掉
 * 输出参数  : 无
 * 返 回 值  :         去掉指定字符的字符串
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : TrimBraket
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 剥掉字符串的方括号
 * 输入参数  : sz  字符串
 * 输出参数  : 无
 * 返 回 值  :      剥掉方括号"[]"的字符串
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro TrimBraket(sz)
{
    sz = TrimString(sz)
    sz = TrimLeftCh(sz, "[")
    sz = TrimRightCh(sz, "]")

    return sz
}

/*****************************************************************************
 * 函 数 名  : GetArraySize
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 剥掉数组的方括号和前后空格
 * 输入参数  : szLine  字符串
 * 输出参数  : 无
 * 返 回 值  :         剥掉方括号"[]"的字符串，如果不是数组，则返回nil
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro GetArraySize(szLine)
{
    var szret

    szret = nil
    
    szLine = TrimString(szLine)            /* 去除前后空格 */

    //查找数组标识"["
    if(szLine[0] == "[")
    {
    
        szLine = TrimRightCh(szLine, ";")   /* 去除右边的分号 */
        szret = TrimBraket(szLine)          /* 去掉方括号 */
    }

    return szret
}

/*****************************************************************************
 * 函 数 名  : PrintStructBasicMember
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 解析普通类型成员
 * 输入参数  : hbuf               输出的文件
               ln                 输出的行号
               preBlank           打印之前补充的空格
               szPrintName        打印函数的名字
               szPrintExtParm     打印函数的额外变量
               szPrintFmt         打印的格式
               arraySize          数组大小
               szStructParmName   遍历的接口体名字
               szChildSymName     结构体成员的名字
               szChildSymNameLen  结构体成员名字的长度
 * 输出参数  : 无
 * 返 回 值  :                 输出之后的最后一行
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : PrintStructStructMember
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 解析结构体成员
 * 输入参数  : hbuf                         输出的文件
               ln                           输出的行号
               preBlank                     打印之前补充的空格
               arraySize                    数组大小
               szAnalyzeStructFunctionName  结构体成员解析的函数名
               szStructParmName             遍历的接口体名字
               szChildSymName               结构体成员的名字
 * 输出参数  : 无
 * 返 回 值  :                 输出之后的最后一行
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : GetStructMember
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 遍历结构体成员
 * 输入参数  : hOutbuf           输出的文件
               ln                输出的行号
               preBlank          打印之前补充的空格
               szPrintName       打印函数的名字
               szPrintExtParm    打印函数的额外变量
               szStructParmName  遍历的接口体名字
               symbolLocation    符号表
 * 输出参数  : 无
 * 返 回 值  :                 输出之后的最后一行
 * 调用关系  : 
 * 其    它  : 

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

        /* 获取结构体成员的类型 */
        szSymbol = makeSymbolOneLine(childsym)       /* 得到拼成一行的结构体成员定义 */
        hword = PeelLastWord(childsym.Symbol)       /* 结构体成员的symbol是"结构体名.结构体成员",所以要获取.后面的 */
        szChildSymName = hword.peelWord

        /* 获取结构体成员名字的最长值 */
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

        szSymTmp = strmid(szSymbol, ich + strlen(szChildSymName), strlen(szSymbol)) /* 获取结构体成员名后面的字符串 */
        arraySize = GetArraySize(szSymTmp)            
        
        szSymTmp = strmid(szSymbol,0,ich)          /* 获取结构体成员名前面的字符串，即结构体成员的类型 */
        szSymTmp = TrimString(szSymTmp)            /* 去除前后空格 */
        if("" == szSymTmp)      /* source inside 不识别的结构体成员 */
        {
            InsBufLine (hbuf, ln, preBlank # "//struct member name:" # childsym.Symbol # " not has type!")
            ln = ln + 1

            ichild = ichild + 1
            continue
        }


        /* 分析是否是指针 */
        if(szSymTmp[strlen(szSymTmp) - 1] == "*")
        {
            ln = PrintStructBasicMember(hbuf, ln, preBlank, szPrintName, szPrintExtParm, "%p", arraySize, szStructParmName, szChildSymName, szChildSymNameLen)

            ichild = ichild + 1
            continue
        }
                
        /* 分析typedef是否定义了基础类型 */
        hword = PeelLastKeyWord(szSymTmp)                      /* 分离出C语言的基本KEY */
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

        /* 分析的最后一个单词 */
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

    /* #define结构体成员名字的最长值 */
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
 * 函 数 名  : makeSymbolOneLine
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月29日
 * 函数功能  : 将符号拼成一行，去掉注释，去掉多余的空格，行与行之间加一个空格
 * 输入参数  : symbolLocation  符号
 * 输出参数  : 无
 * 返 回 值  :                 拼成一行的符号字符串
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro makeSymbolOneLine(symbolLocation)
{
    szSymbol = ""
    if(strlen(symbolLocation) == 0)
    {
       return szSymbol
    }

    hbuf = GetBufHandle(symbolLocation.File)             /* 获取定义所在的文件 */
    ln = symbolLocation.lnFirst
    fIsCommentEnd = true
    while(ln < symbolLocation.lnLim)
    {
        szLine = GetBufLine (hbuf, ln)    /* 获取当前行的字符 */
        RetVal = SkipCommentFromString(szLine,fIsCommentEnd)    /* 去掉注释的内容 */
        szLine = RetVal.szContent
        szLine = TrimString(szLine) /* 去掉空格 */
	    fIsCommentEnd = RetVal.fIsEnd
        szSymbol = cat(szSymbol,szLine)
        szSymbol = cat(szSymbol," ")
        ln = ln + 1
    }
    
    return szSymbol
}

/*****************************************************************************
 * 函 数 名  : ProcessSymbol
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 处理符号表
 * 输入参数  : hOutbuf         输出的文件
               ln              输出的行号
               szPrintName     打印函数的名字
               szPrintExtParm  打印函数的额外变量
               symbolLocation  符号表
               typedefName     typedef的名字
 * 输出参数  : 无
 * 返 回 值  :                 符号类型
 * 调用关系  : 
 * 其    它  : 

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
        szSymbol = makeSymbolOneLine(symbolLocation)       /* 拼成一行 */
        /* 去除符号名字和名字前面部分，留下的就是#define的值 */
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
    if (symbolLocation.Type == "Type Definition")   /* 是typedef就找到真正的符号 */
    {
        szSymbol = makeSymbolOneLine(symbolLocation)       /* 拼成一行 */

        /* 去除符号名字，包括符号名字后面部分 */
        ich = strstr(szSymbol, symbolLocation.Symbol)
        if(0xffffffff == ich)
        {
            Msg("symbol name:" # symbolLocation.Symbol # " not found!")
            stop
        }
        szSymbolTemp = strmid(szSymbol,0,ich)          /* 获取符号名字前面的字符串，即符号的类型 */


        /* 去除第一个typedef单词 */
        hword = PeelFirstWord(szSymbolTemp)
        if(nil == hword)
        {
            Msg("no fisrt word!")
            return hAnalyzeSymbol
        }
        if(hword.peelWord != "typedef")     /* 第一个单词必定是typedef */
        {
            Msg("fisrt word is not \"typedef\"!")
            return hAnalyzeSymbol
        }
        szSymbolTemp = hword.leftWord

        /* 分析是否是函数指针 */
        if(CheckIsFuncPoint(szSymbolTemp))
        {
            Msg("find key word: function pointer")
            
            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = "functioPointer"
            return hAnalyzeSymbol
        }

        /* 分析是否是指针 */
        szSymbolTemp = TrimRight(szSymbolTemp)
        if(szSymbolTemp[strlen(szSymbolTemp) - 1] == "*")
        {
            Msg("find key word: pointer")

            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = "pointer"
            return hAnalyzeSymbol
        }

        /* 分析typedef是否定义了基础类型 */
        hword = PeelFisrtKeyWord(szSymbolTemp)                      /* 分离出C语言的基本KEY */
//        Msg(hword)
        if(CheckIsKey(hword.peelWord))
        {
//            Msg("find key word:" # hword.peelWord)

            hAnalyzeSymbol.type = "Basic key"
            hAnalyzeSymbol.basicKey = hword.peelWord
            return hAnalyzeSymbol
        }

        /* 分析typedef之后的第一个单词 */
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
    else if (symbolLocation.Type == "Structure")    /* 是结构体就遍历成员 */
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

        // 查找szGetStruct函数是否实现，如果实现则不需要添加
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
            /* 遍历成员 */
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
 * 函 数 名  : SetPrintEnv
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 设置打印函数的环境变量
 * 输入参数  : 无
 * 输出参数  : 无
 * 返 回 值  :   无
 * 调用关系  : 
 * 其    它  : 

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
 * 函 数 名  : GetPrintEnv
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2017年1月4日
 * 函数功能  : 打印函数的环境变量
 * 输入参数  : 无
 * 输出参数  : 无
 * 返 回 值  : hPrintEnv.szPrintName打印函数的名称 hPrintEnv.szPrintExtParm打印函数的额外变量(带类型)
 * 调用关系  : 
 * 其    它  : 

*****************************************************************************/
macro GetPrintEnv()
{
    var hPrintEnv

    hPrintEnv.szPrintName = getreg("PRINTNAME")
    hPrintEnv.szPrintExtParm = getreg("PRINTEXTPARM")

    return hPrintEnv
}

/*****************************************************************************
 * 函 数 名  : PrintStruct
 * 负 责 人  : jiangbo,蒋博
 * 创建日期  : 2016年12月28日
 * 函数功能  : 生成打印结构体内容的函数
 * 输入参数  : 无
 * 输出参数  : 无
 * 返 回 值  :   无
 * 调用关系  : 
 * 其    它  : 

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

    /* 判断是否符号 */
    symbolLocation = GetSymbolFromCursor(hbuf, sel.lnFirst, sel.ichFirst)

    ProcessSymbol(hOutbuf, ln, hPrintEnv.szPrintName, hPrintEnv.szPrintExtParm, symbolLocation, nil)

}

macro printStructTest()
{
    szLine = TrimBraket("[{fdsl}]")
    
    msg(szLine)
    stop
}
