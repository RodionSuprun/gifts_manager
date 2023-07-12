import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';

import '../../../data/http/model/gift_dto.dart';

class HomeTrain extends StatelessWidget {
  HomeTrain({Key? key}) : super(key: key);

  final List<CellData> gifts = [
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(firstIcon: true, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
    CellData(
        firstIcon: false, title: "1 300 878,02 ₸", subTitle: "KZ56 ••7890"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                print(gifts);
              },
              child: const Text(
                "Print array",
              ),
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  builder: (context) {
                    return BottomSheet(
                      gifts: gifts,
                      title: "Заголовок меняется в свойствах",
                      subtitle: "",
                      showBack: false,
                    );
                  },
                );
              },
              child: const Text(
                "Only title without back",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  builder: (context) {
                    return BottomSheet(
                      gifts: gifts,
                      title: "Заголовок меняется в свойствах",
                      subtitle: "Дополнительный текст",
                      showBack: true,
                    );
                  },
                );
              },
              child: const Text(
                "Title, subtitle, back, close",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  builder: (context) {
                    return BottomSheet(
                      gifts: gifts,
                      title: "Заголовок меняется в свойствах",
                      subtitle: "Дополнительный текст",
                      showBack: false,
                    );
                  },
                );
              },
              child: const Text(
                "Title, subtitle, close",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
    required this.gifts,
    required this.title,
    required this.subtitle,
    required this.showBack,
  });

  final List<CellData> gifts;
  final String title;
  final String subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            separatorBuilder: (_, index) {
              return const SizedBox(
                height: 22,
              );
            },
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              return ListItemWidget(
                cellData: gifts[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ListItemWidget extends StatefulWidget {
  const ListItemWidget({Key? key, required this.cellData}) : super(key: key);

  final CellData cellData;

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          widget.cellData.isSelected = !widget.cellData.isSelected;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.cellData.firstIcon)
            const Icon(Icons.attach_money, weight: 24),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cellData.title,
                  style: context.theme.textTheme.headline3,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.cellData.subTitle,
                  style: context.theme.textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          if (widget.cellData.isSelected) const Icon(Icons.check, weight: 24),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.showBack,
  });

  final String title;
  final String subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              height: 4,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black38,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBack)
                const Row(
                  children: [
                    Icon(Icons.arrow_back, weight: 24),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.theme.textTheme.headline3,
                    ),
                    if (subtitle.isNotEmpty)
                      Row(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            subtitle,
                            style: context.theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  weight: 24,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

class CellData extends Equatable {
  final bool firstIcon;
  final String title;
  final String subTitle;
  bool isSelected = false;

  CellData({
    required this.firstIcon,
    required this.title,
    required this.subTitle,
  });

  @override
  List<Object?> get props => [firstIcon, title, subTitle, isSelected];
}
