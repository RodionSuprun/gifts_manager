import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/gift/gift_page.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/new_present/view/create_new_present.dart';
import 'package:gifts_manager/resources/app_colors.dart';

import '../../../data/http/model/gift_dto.dart';
import '../../../data/repository/user_repository.dart';
import '../../../di/service_locator.dart';
import '../../../navigation/route_name.dart';
import '../../../resources/illustrations.dart';
import '../bloc/gifts_bloc.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<GiftsBloc>()..add(const GiftsPageLoaded()),
      child: const GiftsPageWidget(),
    );
  }
}

class GiftsPageWidget extends StatelessWidget {
  const GiftsPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GiftsBloc, GiftsState>(
        builder: (context, state) {
          if (state is InitialGiftsLoadingState) {
            return _LoadingWidget();
          } else if (state is NoGiftsState) {
            return _NoGiftsWidget();
          } else if (state is InitialLoadingStateError) {
            return _InitialLoadingErrorWidget();
          } else if (state is LoadedGiftsState) {
            return _GiftsListWidget(
              gifts: state.gifts,
              showLoading: state.showLoading,
              showError: state.showError,
            );
          }
          return const Text("GiftsPage");
        },
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NoGiftsWidget extends StatelessWidget {
  const _NoGiftsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: SvgPicture.asset(
            Illustrations.noGifts,
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Добавьте свой первый подарок",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline2,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _InitialLoadingErrorWidget extends StatelessWidget {
  const _InitialLoadingErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: SvgPicture.asset(
            Illustrations.noGifts,
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Произошла ошибка",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline2,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: () {
              context.read<GiftsBloc>().add(const GiftsLoadingRequest());
            },
            child: Text("Повторить попытку"),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _GiftsListWidget extends StatefulWidget {
  final List<GiftDTO> gifts;
  final bool showLoading;
  final bool showError;

  const _GiftsListWidget(
      {Key? key,
      required this.gifts,
      required this.showLoading,
      required this.showError})
      : super(key: key);

  @override
  State<_GiftsListWidget> createState() => _GiftsListWidgetState();
}

class _GiftsListWidgetState extends State<_GiftsListWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.extentAfter < 300) {
          context.read<GiftsBloc>().add(const GiftsAutoLoadingRequest());
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 32,
        top: 32 + mediaQuery.padding.top,
      ),
      separatorBuilder: (_, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemCount: widget.gifts.length + 1 + ((_haveExtraWidget) ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Text(
            'Подарки:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          );
        }
        if (index == widget.gifts.length + 1) {
          if (widget.showLoading) {
            return Container(
              height: 56,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else {
            if (!widget.showError) {
              print("Error !showerror");
            }
            return Container(
              height: 128,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFFE8F2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Не удалось загрузить данные'),
                  const Text('Попробуйте еще раз'),
                  TextButton(
                    onPressed: () => context
                        .read<GiftsBloc>()
                        .add(const GiftsLoadingRequest()),
                    child: const Text('Попробовать еще раз'),
                  )
                ],
              ),
            );
          }
        }

        final gift = widget.gifts[index - 1];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              RouteName.gift.route,
              arguments: GiftPageArgs(gift.name),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.lightLightBlue100,
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          gift.name,
                          style: context.theme.textTheme.headline2,
                        ),
                        Text(
                          gift.price.toString(),
                          style: context.theme.textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    Illustrations.noGifts,
                    height: 48,
                    width: 48,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool get _haveExtraWidget => widget.showError || widget.showLoading;
}
