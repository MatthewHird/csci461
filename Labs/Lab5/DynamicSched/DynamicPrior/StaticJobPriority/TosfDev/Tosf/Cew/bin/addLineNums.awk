{
    if (match($0, "cew_Ncase\\("))
        { sub("cew_Ncase\\(", "cew_Ncase(" NR ","); }
    if (match($0, "cew_Ecase\\("))
        { sub("cew_Ecase\\(", "cew_Ecase(" NR ","); }
    if (match($0, "cew_Tcase\\("))
        { sub("cew_Tcase\\(", "cew_Tcase(" NR ","); }
    print $0;
}
