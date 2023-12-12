import 'package:flutter/material.dart';

class ClubTile extends StatelessWidget {
  const ClubTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            // constraints: const BoxConstraints(minHeight: 50),
            padding: padding,
            margin: margin,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
              boxShadow: color != null
                  ? [
                      shadow ??
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),

                            spreadRadius: 4,
                            blurRadius: 7,
                            offset: const Offset(
                                2, 4), // changes position of shadow
                          ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    avatar ?? Container(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            titleText != null
                                ? Text(
                                    titleText!,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: listItemTextColor),
                                  )
                                : title ?? Container(),
                            subTitleText != null
                                ? Text(
                                    subTitleText!,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      color: Colors.black54,
                                    ),
                                  )
                                : subTitle ?? Container(),
                            description ?? Container()
                          ],
                        ),
                      ),
                    ),
                    icon ?? Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (firstButtonTitle?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: onFirstButtonTap,
                          child: Text(firstButtonTitle ?? '',
                              style: firstButtonTextStyle),
                        ),
                      ),
                    if (secondButtonTitle?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: onSecondButtonTap,
                          child: Text(
                            secondButtonTitle ?? '',
                            style: secondButtonTextStyle,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
};
  }
}