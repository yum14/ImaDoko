import React from 'react';
import { css } from '@emotion/css';
import { COLORS } from '../common/theme';
import { ContentTemplate, ContentFooter } from '../components';
import { mapLight, mapDark, friendLocation, recievedMessageOnMap, recievedPushNotification, sendingMessage } from '../images';

const styles = {
    container: css`
        display: flex;
        justify-content: center;
        align-items: center;
    `,
    main: css`
        width: 70%;

        @media screen and (max-width: 480px) {
            width: 100%;
            margin: 0 16px;
        }
    `,
    section: css`
        margin-top: 56px;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-flow: column;
        text-align: center;

        &:first-child {
            margin-top: 40px;
        }

        &:last-child {
            margin-bottom: 80px;
        }

        .title {
            width: 600px;
            color: ${COLORS.MAIN};
            font-size: 2.0rem;
            text-align: center;
            margin-bottom: 24px;
            padding: 8px;
            position: relative;
            border-bottom: 3px solid ${COLORS.MAIN}
        }

        .desc {
            p {
                margin: 0;
            }
        }

        .deviceImageContainer {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-flow: row;
            
            img {
                width: 160px;
                margin: 0 8px;
            }
        }

        @media screen and (max-width: 480px) {
            .title {
                width: 98%;
                min-width: auto;
            }
        }
    `,
    contentFooter: css`
        margin: 0 auto 40px;
    `
}

const Introduction = () => {
    return (
        <ContentTemplate>
            <div className={styles.container}>
                <div className={styles.main}>
                    <section className={styles.section}>
                        <h2 className='title'>位置情報のシェアに特化したアプリ</h2>

                        <div className='desc'>
                            <p>Imadokoは位置情報の共有に特化したアプリです。</p>
                            <p>友だちへ現在地の共有を依頼、またはあなたの現在地を送信できます。</p>
                        </div>

                        <div className='deviceImageContainer'>
                            <img src={mapLight} alt="マップ（ライト）" />
                            <img src={mapDark} alt="マップ（ダーク）" />
                        </div>
                    </section>

                    <section className={styles.section}>
                        <h2 className='title'>メッセージアプリより手軽に、わかりやすく</h2>

                        <div className='desc'>
                            <p>操作は単純で簡単です。</p>
                            <p>最小３タップで友だちへメッセージを送信できます。</p>
                        </div>

                        <div className='deviceImageContainer'>
                            <img src={sendingMessage} alt="メッセージ送信" />
                            <img src={friendLocation} alt="位置情報の確認" />
                        </div>
                    </section>

                    <section className={styles.section}>
                        <h2 className='title'>プッシュ通知に対応</h2>

                        <div className='desc'>
                            <p>友だちからのリクエストはプッシュ通知されます。</p> 
                            <p>アプリ起動中でも通知されるため、見逃すことはありません。</p>
                        </div>

                        <div className='deviceImageContainer'>
                            <img src={recievedPushNotification} alt="プッシュ通知" />
                            <img src={recievedMessageOnMap} alt="アプリ上の通知" />
                        </div>
                    </section>
                </div>
            </div>

            <ContentFooter className={styles.contentFooter} firstLink={'contact'} secondLink={'policy'} />

        </ContentTemplate>
    )
};

export default Introduction;
